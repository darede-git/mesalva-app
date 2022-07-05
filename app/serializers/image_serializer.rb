# frozen_string_literal: true

class ImageSerializer < ActiveModel::Serializer
  include SerializationHelper
  attributes :id, :image, :created_by
end
