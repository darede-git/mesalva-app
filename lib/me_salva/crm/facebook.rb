# frozen_string_literal: true

module MeSalva
  module Crm
    class Facebook
      def send_purchase_event(order)
        @order = order
        @package = @order.package
        HTTParty.post(facebook_api_path, headers: headers, body: purchase_body)
      end

      private

      def headers
        { "Content-Type": "application/json"}
      end

      def purchase_body
        { "data": [purchase_event],
          "access_token": ENV['FACEBOOK_ACCESS_TOKEN'] }.to_json
      end

      def facebook_api_path
        "https://graph.facebook.com/v13.0/#{ENV['FACEBOOK_PIXEL']}/events"
      end

      def purchase_event
          {
            "event_name": "Purchase",
            "event_time": DateTime.now.to_time,
            "user_data": @order.facebook_ads_infos,
            "contents": [
              {
                "id": @package.slug,
                "quantity": 1,
                "delivery_category": "home_delivery"
              }
            ],
            "custom_data": {
              "currency": "brl",
              "value": @order.price_paid
            },
            "event_source_url": "https://www.mesalva.com/checkout/#{@package.slug}",
            "action_source": "website"
          }
      end
    end
  end
end
