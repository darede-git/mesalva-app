# frozen_string_literal: true

require 'me_salva/signature/order'

class ExpiredSubscriptionsWorker < BaseSignaturesWorker
  def perform
    orders = Order.expired_subscription_orders.by_iugu 
    unless orders.nil?
      orders.each do |order|
        begin
          MeSalva::Signature::Order.new.renew(order)
        rescue RestClient::BadGateway
          create_crm('checkout_error_subs_renew', order.user, order.last)
        end
      end
    end
  end
end
