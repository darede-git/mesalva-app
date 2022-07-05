# frozen_string_literal: true

class PostbacksController < ApplicationController
  include IntercomHelper
  before_action :set_entity, only: %w[rdstation create]
  before_action :create_crm_event, if: :charge_fail?,  only: %w[rdstation create]
  before_action :set_revenuecat, only: :revenuecat

  def health
    render_results('health')
  end

  def create
    if @entity
      return render_ok(@entity) if double_request?
      return render_no_content if postback.process

      render_method_not_allowed
    else
      render_not_found
    end
  rescue NoMethodError => e
    NewRelic::Agent.notice_error(e, params)
    render nothing: true, status: :bad_request
  end

  def revenuecat
    return render_bad_request unless revenuecat_info_ok?

    return render_unprocessable_entity unless revenuecat_information_for_update_ok?

    return render json: revenuecat_update_transaction if revenuecat_initial_purchase?

    return render json: revenuecat_subscription_renew if previous_revenuecat_renewal?

    render json: @revenuecat.default_ok, status: :ok
  end

  def rdstation
    render json: RdstationLog.create(rdstation_params), status: :ok
  end

  def typeform
    return render_no_content if not_persona_form?
    return render_no_content if params['form_response']['hidden']['uid'].nil?

    result = MeSalva::User::Persona.update_user_persona_from_typeform_response(params[:form_response])
    render_ok(result)
  end

  private

  def not_persona_form?
    return true if ENV['TYPEFORM_PERSONA_FORM_ID'].nil?

    ENV['TYPEFORM_PERSONA_FORM_ID'].split(',').include?(params['form_response']['form_id']) == false
  end

  def rdstation_params
    params.permit(:trigger, leads: rdstation_leads_params)
  end

  def rdstation_leads_params
    [:id, :email, :name, :company, :job_title, :bio,
     :public_url, :created_at, :opportunity, :number_conversions,
     :user, :website, :personal_phone, :mobile_phone, :city, :state,
     :lead_stage, :last_marked_opportunity_date, :uuid, :fit_score, :interest,
     { first_conversion: {}, last_conversion: {}, custom_fields: {}, tags: [] }]
  end

  def create_crm_event
    update_intercom_user(find_user_by_entity,
                         checkout_error_code: charge_fail_code,
                         last_checkout_error_date: Time.now)
  end

  def find_user_by_entity
    return @entity.order.user if payment_postback?

    @entity.user
  end

  def charge_fail?
    next_status == 'refused'
  end

  def charge_fail_code
    if payment_postback?
      params.dig(:transaction, :acquirer_response_code)
    else
      params.dig(:subscription, :current_transaction, :acquirer_response_code)
    end
  end

  def double_request?
    @entity.pagarme_status == next_status if payment_postback?
  end

  def postback
    MeSalva::Payment::Pagarme::Postback.new(postback_attributes)
  end

  def postback_attributes
    { entity: @entity, status: next_status,
      current_transaction_id: current_transaction_id,
      next_recurrence_date: next_recurrence_date,
      amount_paid: amount_paid, payment_method: payment_method,
      bank_slip_url: bank_slip_url, pix_qr_code: pix_qr_code, error_code: charge_fail_code }
  end

  def next_status
    params['current_status']
  end

  def payment_postback?
    params['object'] == 'transaction'
  end

  def subscription_postback?
    params['object'] == 'subscription'
  end

  def current_transaction_id
    params.dig('subscription', 'current_transaction', 'id')
  end

  def next_recurrence_date
    return if current_period_end.nil? || current_period_end.empty?

    Time.parse current_period_end
  end

  def current_period_end
    params.dig('subscription', 'current_period_end')
  end

  def amount_paid
    params.dig('subscription', 'current_transaction', 'amount').to_i
  end

  def payment_method_param
    params.dig('subscription', 'payment_method')
  end

  def bank_slip_url
    params.dig('subscription', 'current_transaction', 'boleto_url')
  end

  def pix_qr_code
    params.dig('subscription', 'current_transaction', 'pix_qr_code')
  end

  def payment_method
    return 'card' if card_param?
    return 'bank_slip' if bank_slip_param?
    return 'pix' if pix_param?
  end

  def card_param?
    payment_method_param == 'credit_card'
  end

  def bank_slip_param?
    payment_method_param == 'boleto'
  end

  def pix_param?
    payment_method_param == 'pix'
  end

  def set_entity
    @entity = if payment_postback?
                find_by_payment
              elsif subscription_postback?
                find_by_subscription
              end
  end

  def reprocessed?
    !pagarme_original_transaction_id.nil?
  end

  def pagarme_original_transaction
    pagarme_transaction = PagarmeTransaction.find_by_transaction_id(
      pagarme_original_transaction_id
    )
    pagarme_transaction.order_payment.update(reprocessed: true)
    pagarme_transaction
  end

  def pagarme_original_transaction_id
    params.dig('transaction', 'metadata', 'pagarme_original_transaction_id')
  end

  def find_by_payment
    return pagarme_original_transaction.order_payment if reprocessed?

    PagarmeTransaction.find_by_transaction_id(params[:id]).order_payment
  end

  def find_by_subscription
    PagarmeSubscription.find_by_pagarme_id(params[:id]).subscription
  end

  def revenuecat_initial_purchase?
    params['event']['type'] == 'INITIAL_PURCHASE' if revenuecat_event_present?
  end

  def revenuecat_renewal?
    params['event']['type'] == 'RENEWAL' if revenuecat_event_present?
  end

  def previous_revenuecat_renewal?
    revenuecat_renewal? && @revenuecat.previous_transaction?
  end

  def revenuecat_event_present?
    params['event'].present?
  end

  def revenuecat_info_ok?
    @revenuecat.present? &&
      @revenuecat.metadata_ok? &&
      @revenuecat.valid_store? &&
      revenuecat_event_present?
  end

  def revenuecat_update_transaction
    @revenuecat.update_store_transaction_metadata
  end

  def revenuecat_subscription_renew
    @revenuecat.subscription_renew
  end

  def revenuecat_information_for_update_ok?
    @revenuecat.information_for_update_ok?
  end

  def set_revenuecat
    if revenuecat_initial_purchase?
      @revenuecat = MeSalva::Payment::Revenuecat::InitialPurchase.new(params['event'])
    elsif revenuecat_renewal?
      @revenuecat = MeSalva::Payment::Revenuecat::Renewal.new(params['event'])
    elsif revenuecat_event_present?
      @revenuecat = MeSalva::Payment::Revenuecat::Postback.new(params['event'])
    end
  end
end
