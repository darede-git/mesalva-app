# frozen_string_literal: true

module MeSalva
  module Subscription
    class RenewerBase
      DEFAULT_REJECTED_LIST = %w[id updated_at created_at].freeze

      def renew
        @renewed_entity = @entity_to_renew.class.new(renew_params).tap do |e|
          e.assign_attributes(@new_entity_attributes)
        end
      end

      private

      def renew_params
        @entity_to_renew.as_json.except(*rejected_list)
      end

      def rejected_list
        @not_heritable_attributes + DEFAULT_REJECTED_LIST
      end
    end
  end
end
