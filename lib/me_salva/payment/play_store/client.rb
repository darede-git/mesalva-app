# frozen_string_literal: true

require 'me_salva/payment/play_store/invoice'
require 'me_salva/error/google_api_connection_error'

module MeSalva
  module Payment
    module PlayStore
      class Client
        def initialize
          set_new_access_token
        end

        def subscription_last_invoice_from(order)
          response = order_info_request(order)
          raise_unless_valid_response_status(response)
          Invoice.new(response.parsed_response)
        end

        def refund(order)
          response = refund_request(order)
          successful_refund?(response)
        end

        private

        def set_new_access_token
          response = access_token_request
          raise_unless_valid_response_status(response)
          @access_token ||= response.parsed_response['access_token']
        end

        def successful_refund?(response)
          response.code == 204
        end

        def access_token_request
          HTTParty.post(ENV['GOOGLE_OAUTH_API_URL'],
                        body: {
                          grant_type: 'refresh_token',
                          client_id: ENV['GOOGLE_API_CLIENT_ID'],
                          client_secret: ENV['GOOGLE_API_CLIENT_SECRET'],
                          refresh_token: ENV['GOOGLE_API_REFRESH_TOKEN']
                        })
        end

        def raise_unless_valid_response_status(response)
          return if response.code == 200

          raise MeSalva::Error::GoogleApiConnectionError.new(
            response.code,
            response.parsed_response
          )
        end

        def order_info_request_url(order)
          url_with_order_data(order) + access_token_url_param
        end

        def url_with_order_data(order)
          subscription_id = order.broker_data['productId']
          order_token = order.broker_data['purchaseToken']
          ENV['GOOGLE_PLAY_API_URL'] + \
            "#{ENV['PLAY_STORE_PACKAGE_NAME']}/purchases/subscriptions/"\
            "#{subscription_id}/tokens/#{order_token}"
        end

        def access_token_url_param
          "?access_token=#{@access_token}"
        end

        def refund_url(order)
          "#{url_with_order_data(order)}:refund#{access_token_url_param}"
        end

        def order_info_request(order)
          HTTParty.get(order_info_request_url(order))
        end

        def refund_request(order)
          HTTParty.post(refund_url(order))
        end
      end
    end
  end
end
