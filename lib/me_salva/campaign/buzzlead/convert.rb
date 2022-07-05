# frozen_string_literal: true

require 'me_salva/error/buzzlead_api_connection_error'

module MeSalva
  module Campaign
    module Buzzlead
      class Convert
        def initialize(order)
          @order = order
        end

        def create
          create_response
          raise_unless_valid_response_status
        end

        def confirm
          confirm_response
          raise_unless_valid_response_status
          @order.update!(buzzlead_processed: true)
        end

        private

        def create_response
          @response = HTTParty.post(create_url, headers: headers, body: body)
        end

        def confirm_response
          @response = HTTParty.post(confirm_url, headers: headers)
        end

        def create_url
          "#{ENV['BUZZLEAD_API_URL']}notification/convert"
        end

        def confirm_url
          ENV['BUZZLEAD_API_URL'] + "bonus/status/#{@order.token}/confirmado"
        end

        def headers
          { "x-api-token-buzzlead" => ENV['BUZZLEAD_API_TOKEN'],
            "x-api-key-buzzlead" => ENV['BUZZLEAD_API_KEY'] }
        end

        def body
          { codigo: @order.utm.utm_content,
            pedido: @order.token,
            total: total,
            nome: @order.user.name,
            email: @order.user.email }
        end

        def raise_unless_valid_response_status
          return true if valid_response?

          raise MeSalva::Error::BuzzleadApiConnectionError.new(
            @response.code,
            @response.parsed_response
          )
        end

        def valid_response?
          @response.code == 200 && @response.parsed_response['success']
        end

        def total
          (@order.price_paid.to_f * 0.05).round(2)
        end
      end
    end
  end
end
