# frozen_string_literal: true

require 'me_salva/payment/play_store/subscription'
require 'me_salva/error/google_api_connection_error'

class RenewPlayStoreSubscriptionsWorker
  include Sidekiq::Worker

  def perform
    play_store_broker = MeSalva::Payment::PlayStore::Subscription.new
    ::Order.expired_orders.by_play_store.each do |order|
      begin
        play_store_broker.process(order)
      rescue MeSalva::Error::GoogleApiConnectionError => exception
        NewRelic::Agent.notice_error(exception,
                                     response_body: exception.body,
                                     status_code: exception.status_code)
      end
    end
  end
end
