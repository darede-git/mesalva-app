# frozen_string_literal: true

module MeSalva
  module Delivery
    class DeliveryTracking
      attr_reader :tracking_code, :error, :event_type

      PERMITED_FIELDS = %w[description date unity city state]

      def initialize(tracking_code)
        @tracking_code = tracking_code
      end

      def all_events
        raise NotImplementedError, "Implement this method in a child class"
      end

      def posted?
        raise NotImplementedError, "Implement this method in a child class"
      end

      def out_for_delivery?
        raise NotImplementedError, "Implement this method in a child class"
      end

      def delivered?
        raise NotImplementedError, "Implement this method in a child class"
      end
    end
  end
end
