# frozen_string_literal: true

module MeSalva
  module Delivery
    class DeliveryShipping
      attr_reader :delivery_availability, :tangible_product, :uf

      def initialize(**params)
        @delivery_availability = params[:delivery_availability]
        @tangible_product = params[:tangible_product]
        @uf = params[:uf]
      end

      def cheapest_service
        raise NotImplementedError, "Implement this method in a child class"
      end

      def service_information(_service_name)
        raise NotImplementedError, "Implement this method in a child class"
      end

      def generate_posting_code
        raise NotImplementedError, "Implement this method in a child class"
      end
    end
  end
end
