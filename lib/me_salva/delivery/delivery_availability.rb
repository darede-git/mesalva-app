# frozen_string_literal: true

module MeSalva
  module Delivery
    class DeliveryAvailability
      attr_reader :sender_zipcode, :recipient_zipcode

      def initialize(**params)
        @sender_zipcode = params[:sender_zipcode]
        @recipient_zipcode = params[:recipient_zipcode]
      end

      def service_available?(_service_type)
        raise NotImplementedError, "Implement this method in a child class"
      end

      def services_available
        raise NotImplementedError, "Implement this method in a child class"
      end
    end
  end
end
