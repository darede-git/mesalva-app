# frozen_string_literal: true

class EducationSegmentSerializer < ActiveModel::Serializer
  include SerializationHelper
  attributes :slug, :name, :image
end
