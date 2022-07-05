# frozen_string_literal: true

class CheckoutsController < ApplicationController
  include UtmHelper
  include CrmEvents
  include AddressConcern
  include ErrorHandler
  include RdStationHelper

  before_action -> { authenticate(%w[user]) }
  before_action :validate_discount
  before_action :validate_package
  after_action :send_email_with_bank_slip, only: :create, if: :bank_slip?

  rescue_from PagarMe::ValidationError, with: :pagarme_validation_handler

  def create
    if set_order
      render_order_created
    else
      event_card_error if payment_methods_include_card?

      create_checkout_error_event(@order.errors.messages.to_s)
      render_unprocessable_entity(@order.errors.messages)
    end
  end

  private

  def event_card_error
    send_rd_station_event(event: 'payment_card_error',
                          params: { user: current_user,
                                    package: package })

    create_crm('wpp_cartao_error', current_user, @order)
  end

  def payment_methods_include_card?
    methods = checkout_params[:payment_methods].map do |payment|
      payment[:method]
    end
    methods.include?("card")
  end

  def validate_package
    @package = Package.find(params[:package_id]) if params[:package_id]
    return if @package&.active

    render_unprocessable_entity(t('errors.messages.inactive_package'))
  end

  def validate_discount
    return unless params[:discount_id].present?

    @discount = Discount.find_by_token(params[:discount_id])
    return render_discount_invalid unless valid_discount?
  end

  def valid_discount?
    payment_discount.valid?(package, @discount, current_user)
  end

  def payment_discount
    @payment_discount ||= MeSalva::Payment::Discount.new
  end

  def package
    Package.find(params[:package_id])
  end

  def render_discount_invalid
    render_unprocessable_entity(t('discount.invalid_discount'))
  end

  def set_order
    @order = Order.new(checkout_params.except(:payment_methods))
    set_payment_methods
    @order.discount_in_cents = discount_in_cents
    @order.price_paid = price_paid_with_discount if price

    return unless @order.save

    process_order
  end

  def process_order
    call_intercom_actions
    @pararme_response = MeSalva::Checkout.new(checkout_attributes).process
  end

  def set_payment_methods
    payment_methods = Array.wrap(checkout_params[:payment_methods])
    @order.payments = payment_methods.map do |payment|
      attrs = { payment_method: payment[:method],
                amount_in_cents: payment[:amount_in_cents],
                installments: payment[:installments],
                card_token: payment[:token] }
      set_attrs_metadata(attrs, payment) if payment[:method] == 'card'
      ::OrderPayment.new(attrs)
    end
  end

  def valid_pagarme_error_message(message)
    return message unless message =~ /card_hash inválido/

    I18n.t('errors.messages.invalid_card_hash')
  end

  def create_checkout_error_event(message)
    update_intercom_user(current_user,
                         checkout_error_message: message,
                         checkout_error_code: error_code_message(message),
                         package_name: @order.package.name,
                         package_url: @order.package.checkout_url)
    create_crm('checkout_error_submission', @order.user, @order, message)
  end

  def error_code_message(message)
    "1000-#{message}"
  end

  def set_attrs_metadata(attrs, payment)
    attrs[:metadata] = { last4: payment[:last4], brand: payment[:brand] }
  end

  def checkout_attributes
    { order: @order,
      user: current_user,
      name: checkout_params[:name],
      email: checkout_params[:email] }
  end

  def render_order_created
    create_crm('checkout_success', @order.reload.user, @order)
    render json: @order, include: %i[address package],
           meta: metadata, status: :created
  end

  def call_intercom_actions
    create_crm(event_name, @order.user, @order)
    update_intercom_phone_number if phone_attributes?
    return unless @order.bank_slip?

    create_bank_slip_event
  end

  def update_intercom_phone_number
    update_intercom_user(@order.user, phone_checkout: complete_phone_number)
  end

  def phone_attributes?
    %w[phone_number phone_area].all? { |field| checkout_params[field] }
  end

  def complete_phone_number
    "#{checkout_params[:phone_area]} #{checkout_params[:phone_number]}"
  end

  def event_name
    "checkout_submit_#{@order.checkout_method}"
  end

  def create_bank_slip_event
    ::CrmRdstationBankSlipWorker.perform_async(@order.id)
    create_crm('wpp_boleto_gerado', current_user, @order)
    update_intercom_user(@order.user, boleto_gerado: @order.package_name,
                                      data_geracao_boleto: @order.created_at,
                                      data_vencimento_boleto: Time.now + 3.days)
  end

  def checkout_params
    checkout_merged_attributes
      .permit(:package_id, :broker, :installments, :email,
              :cpf, :nationality, :discount_id, :user_id, :currency,
              :phone_number, :phone_area,
              facebook_ads_infos: facebook_ads_infos_attributes,
              payment_methods: payment_methods_attributes,
              address_attributes: address_attributes,
              utm_attributes: utm_attributes,
              complementary_package_ids: [])
      .tap { |p| ensure_installment!(p) }
  end

  def checkout_merged_attributes
    params.merge(user_id: current_user.id)
          .merge(utm_attributes: utm_attr)
          .merge(broker: 'pagarme')
          .merge(discount_id: @discount.try(:id))
          .merge(facebook_ads_infos: facebook_ads_infos)
  end

  def facebook_ads_infos
    infos = {
      client_ip_address: request.remote_ip,
      client_user_agent: request.user_agent,
      fbc: request.headers['HTTP_FBC'],
      fbp: request.headers['HTTP_FBP']
    }
    update_facebook_header(infos, 'fbc')
    update_facebook_header(infos, 'fbp')
  end

  def update_facebook_header(infos, name)
    header_name = "HTTP_#{name.upcase}"
    infos[name.to_sym] = request.headers[header_name] if request.headers[header_name].present?
    infos
  end

  def payment_methods_attributes
    %i[method token last4 brand amount_in_cents installments]
  end

  def facebook_ads_infos_attributes
    %i[client_ip_address client_user_agent fbc fbp]
  end

  def metadata
    return { pdf: @order.pdf, barcode: @order.barcode } if @order.bank_slip?

    { qr_code: @order.qr_code } if @order.pix?
  end

  # Some requests are allowed to send no installment, so here we default to 1.
  def ensure_installment!(p)
    p[:installments] ||= 1
  end

  def amount_with_discount
    DecimalAmount.new(price).to_i - discount_in_cents
  end

  def discount_in_cents
    DecimalAmount.new(discount_value).to_i
  end

  def discount_value
    return 0 unless @discount

    @discount.deduct_discount(price)
  end

  def price
    cp_total = ComplementaryPackage
               .sum_complementary_packages_prices(checkout_params[:complementary_package_ids],
                                                  checkout_method)
    return @order.price.value + cp_total if @order&.package

    @price ||= Price.by_package_and_price_type(params[:package_id], checkout_method)
    @price.value + cp_total
  end

  def checkout_method
    return 'credit_card' if @order.checkout_method == 'multiple'

    @order.checkout_method
  end

  def price_paid_with_discount
    price - discount_value
  end

  def send_email_with_bank_slip
    CheckoutMailer.with(order: @order,
                        email_type: 'bank_slip_after_checkout')
                  .bank_slip_email
                  .deliver_now
    SendEmailBankSlipLastDayWorker.perform_in(1.day, @order.id)
    SendEmailBankSlipOverduedWorker.perform_in(2.days, @order.id)
  end

  def bank_slip?
    @order.bank_slip?
  end
end
