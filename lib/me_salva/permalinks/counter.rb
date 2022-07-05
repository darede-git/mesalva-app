# frozen_string_literal: true

module MeSalva
  module Permalinks
    class Counter
      attr_reader :permalink

      def initialize(attrs)
        @permalink = attrs[:permalink]
      end

      def seconds_duration
        current_permalink_entity.seconds_duration
      end

      def node_module_count
        current_permalink_entity.node_module_count if current_permalink_entity
                                                      .instance_of? Node
      end

      def medium_count
        current_permalink_entity.medium_count unless current_permalink_entity
                                                     .instance_of? Medium
      end

      private

      def current_permalink_entity
        @permalink.medium ||
          @permalink.item ||
          @permalink.node_module ||
          @permalink.nodes.last
      end
    end
  end
end
