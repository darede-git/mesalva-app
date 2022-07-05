# frozen_string_literal: true

module MeSalva
  module Search
    class BaseEntityIndexer
      def initialize(entity, search_data = [])
        @entity = entity
        @search_data = search_data
      end

      def react_to_action(action)
        send("#{action}_search_data")
      end

      def update_search_data
        @search_data.update_all(params_for_update)
      end

      def create_search_data; end

      def destroy_search_data
        @search_data.destroy_all
      end
    end
  end
end
