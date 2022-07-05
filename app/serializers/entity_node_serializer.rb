# frozen_string_literal: true

class EntityNodeSerializer < BaseNodeSerializer
  has_many :media, serializer: EntityMediumSerializer
  has_many :node_modules

  attributes :children, :parent, :active, :token

  private

  def relatives_serializer
    EntityNodeRelativesSerializer
  end
end
