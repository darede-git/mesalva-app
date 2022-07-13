# frozen_string_literal: true

module MeSalva
  module Delivery
    module TangibleProducts
      class TangibleProductsTracking < DeliveryTracking
        DELIVERY_DRIVERS = { correios: MeSalva::Delivery::Drivers::Correios::CorreiosTracking }.freeze

        attr_reader :driver

        def initialize(tracking_code)
          @tracking_code = tracking_code
          super(tracking_code)
          @driver = DELIVERY_DRIVERS[ENV['DELIVERY_DRIVER'].to_sym]
        end

        def all_events
          driver.new(@tracking_code).all_events
        end

        def posted?
          driver.new(@tracking_code).posted?
        end

        def out_for_delivery?
          driver.new(@tracking_code).out_for_delivery?
        end

        def delivered?
          driver.new(@tracking_code).delivered?
        end
      end
    end
  end
end
