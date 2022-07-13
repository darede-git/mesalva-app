# frozen_string_literal: true

module MeSalva
  module Delivery
    module TangibleProducts
      class TangibleProductsShipping < DeliveryShipping
        DELIVERY_DRIVERS = { correios: Drivers::Correios::CorreiosShipping }.freeze

        attr_reader :driver

        def initialize(**params)
          @params = params
          super(params)
          @driver = DELIVERY_DRIVERS[ENV['DELIVERY_DRIVER'].to_sym]
        end

        def cheapest_service
          driver.new(@params).cheapest_service
        end

        def service_information(service_name)
          driver.new(@params).service_information(service_name)
        end

        def generate_posting_code
          driver.new(@params).generate_posting_code
        end
      end
    end
  end
end
