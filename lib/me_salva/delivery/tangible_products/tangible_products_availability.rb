# frozen_string_literal: true

module MeSalva
  module Delivery
    module TangibleProducts
      class TangibleProductsAvailability < DeliveryAvailability
        DELIVERY_DRIVERS = { correios: MeSalva::Delivery::Drivers::Correios::CorreiosAvailability }
                           .freeze

        attr_reader :driver

        def initialize(**params)
          @params = params
          super(params)
          @driver = DELIVERY_DRIVERS[ENV['DELIVERY_DRIVER'].to_sym]
        end

        def service_available?(service_type)
          driver.new(@params).service_available?(service_type)
        end

        def services_available
          driver.new(@params).services_available
        end
      end
    end
  end
end
