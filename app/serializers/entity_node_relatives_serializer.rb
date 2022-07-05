# frozen_string_literal: true

class EntityNodeRelativesSerializer < ActiveModel::Serializer
  include SerializationHelper

  attributes :id,
             :name,
             :slug,
             :image
end
