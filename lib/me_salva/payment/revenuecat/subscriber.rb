# frozen_string_literal: true

module MeSalva
  module Payment
    module Revenuecat
      class Subscriber < ActiveModelSerializers::Model
        include HTTParty

        PUBLIC_API_KEY = ENV['REVENUE_CAT_PUBLIC_API_KEY']
        SECRET_API_KEY = ENV['REVENUE_CAT_SECRET_API_KEY']
        API_BASE_URL = 'https://api.revenuecat.com/v1/subscribers/'

        HEADERS = { "Accept" => "application/json",
                    "Content-Type" => "application/json",
                    "Authorization" => "Bearer #{SECRET_API_KEY}" }.freeze

        def initialize(app_user_id = nil)
          @app_user_id = app_user_id
        end

        def revoke_subscription(product_id)
          request('post', "#{@app_user_id}/subscriptions/#{product_id}/revoke")
        end

        private

        def request(method, path, body = '')
          response = HTTParty.send(method, "#{API_BASE_URL}#{path}", body: body, headers: HEADERS)
          {
            body: response.body,
            ok: response.code == 200
          }
        end
      end
    end
  end
end
