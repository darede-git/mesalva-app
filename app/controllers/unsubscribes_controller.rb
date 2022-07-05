# frozen_string_literal: true

require 'me_salva/payment/iugu/subscription'

class UnsubscribesController < ApplicationController
  include UtmHelper
  include CrmEvents
  include IntercomHelper
  include RdStationHelper
  before_action -> { authenticate(%w[user]) }
  before_action :set_subscription
  after_action :update_auth_headers

  def update
    return render_not_found unless @subscription

    if unsubscribe
      deactivate_subscription
      unsubscribe_events
      render_ok(@subscription)
    else
      render_unprocessable_entity
    end
  rescue RestClient::GatewayTimeout
    render_gateway_timeout('unsubscribe_timeout')
  end

  private

  def unsubscribe
    return pagarme_unsubscribe if @subscription.pagarme?

    iugu_unsubscribe if @subscription.iugu?
  end

  def deactivate_subscription
    @subscription.update(active: false)
  end

  def package
    @subscription.orders.last.package
  end

  def set_subscription
    @subscription = Subscription.find_by_token_and_user_id(
      params[:subscription_id],
      current_user.id
    )
  end

  def unsubscribe_events
    create_crm('unsubscribe', current_user)
    CrmRdstationUnsubscriberEventWorker.perform_async(@subscription.id)
    send_rd_station_checkout_event(:expiration_event, current_user, package)
    return unless unique_access?

    current_user.state_machine.transition_to(:ex_subscriber)
  end

  def unique_access?
    Access.by_user_active_in_range(@subscription.user).count <= 1
  end

  def iugu_unsubscribe
    subscription_client.suspend(@subscription.broker_id)
  end

  def pagarme_unsubscribe
    MeSalva::Payment::Pagarme::Unsubscribe.new(
      subscription: @subscription
    ).perform
  end

  def subscription_client
    @subscription_client ||= MeSalva::Payment::Iugu::Subscription.new
  end
end
