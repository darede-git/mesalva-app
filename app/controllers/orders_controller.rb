# frozen_string_literal: true

class OrdersController < ApplicationController
  include InAppPurchaseHelper
  include UtmHelper
  include AddressConcern

  wrap_parameters include: %i[package_id checkout_method
                              broker installments
                              address_attributes email
                              cpf nationality]

  before_action -> { authenticate(%w[user admin]) }, expect: :pre_approved_status
  before_action -> { authenticate(%w[admin]) }, only: :pre_approved_status
  before_action :set_order, only: %i[show update pre_approved_status reprocess]
  before_action :validate_order_and_owner, only: :update

  rescue_from ActiveRecord::RecordInvalid do |exception|
    attrs = order_params.merge!('action': params['action'])
    NewRelic::Agent.notice_error(exception, attrs)
    render_unprocessable_entity
  end

  def index
    render json: orders, include: :package, status: :ok
  end

  def show
    return render_not_found unless @order

    render json: @order, meta: metadata, include: :package, status: :ok
  end

  def reprocess
    return render_not_found unless @order

    MeSalva::Payment::Pagarme::Reprocess.new.by_order(@order)
    render json: @order, meta: metadata, include: :package, status: :ok
  end

  def create
    return render_unprocessable_entity unless broker_data

    @order = find_or_create
    @order.save!
    @order.transition_to_paid
    render json: @order, include: :package, status: :created
  end

  def update
    return render_unprocessable_entity if invalid_status_change?

    if params[:status] == 8
      @order.payment_proof = params[:payment_proof]
      @order.state_machine.transition_to(:pre_approved)
      return render_ok(@order)
    end

    @order.update!(order_update_params)
    render_ok(@order)
  end

  private

  def invalid_status_change?
    return true if new_status_pending? && user_signed_in?

    false
  end

  def new_status_pending?
    params[:status] == '8'
  end

  def find_or_create
    find_order || Order.new(order_params)
  end

  def can_update_status?
    return false unless (@order.status == 1) && @order.bank_slip?

    true
  end

  def find_order
    new_broker = broker
    new_broker = "app_store" if broker == "apple_store"

    "#{new_broker}_transaction".camelize.constantize
                               .find_by_transaction_id(transaction_id)
                               .try :order
  end

  def order_params
    params.merge(user_id: current_user.id, utm_attributes: utm_attr,
                 package_id: package_by_mobile.try(:id),
                 expires_at: order_expires_at, broker_invoice: transaction_id)
          .merge(payment_attributes).permit(permitted_attributes)
  end

  def payment_attributes
    { price_paid: fill_price_paid, payments_attributes: [new_payment] }
  end

  def order_update_params
    params.permit(update_permitted_attributes)
  end

  def package_by_mobile
    return unless mobile_product_param.present?

    Package.public_send("find_by_#{broker}_product_id", mobile_product_param)
  end

  def order_expires_at
    return unless broker_data['purchaseTime'] || broker_data['purchase_date_ms']

    Time.at(expires_at_param / 1000) + 1.month
  end

  def set_order
    @order = order_on_current_user
  end

  def order_on_current_user
    return order_by_token_and_user_id if user_signed_in?

    Order.find_by_token(params[:id])
  end

  def order_by_token_and_user_id
    Order.find_by_token_and_user_id(params[:id], current_user.id)
  end

  def validate_order_and_owner
    return render_not_found unless @order.present?

    render_unauthorized unless current_user_owns_order?
  end

  def current_user_owns_order?
    return true if admin_signed_in?

    @order.user == current_user
  end

  def orders
    return Order.by_user(find_user_by_uid) if admin_with_user_filter

    Order.by_user(current_user) if user_signed_in?
  end

  def admin_with_user_filter
    params['user_uid'] && admin_signed_in?
  end

  def find_user_by_uid
    @user = User.find_by_uid(params[:user_uid])
  end

  def metadata
    { pdf: @order.pdf } if @order&.pdf
  end

  def fill_price_paid
    BigDecimal(params[:amount_in_cents]) / 100 if params[:amount_in_cents]
  end
end
