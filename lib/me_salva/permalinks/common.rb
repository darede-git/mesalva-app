# frozen_string_literal: true

module MeSalva
  module Permalinks
    module Common
      def entity_permalinks(entity = @entity)
        permalinks = entity.permalinks.ending_with_slug(entity.slug)
        permalinks = entity.permalinks.by_slug(entity.slug.to_s) if permalinks.empty?
        permalinks
      end
    end
  end
end
