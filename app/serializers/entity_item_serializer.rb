# frozen_string_literal: true

class EntityItemSerializer < BaseItemSerializer
  has_many :media, serializer: EntityMediumSerializer
  has_many :node_modules
end
