# frozen_string_literal: true

class EducationSegment::AreaSubjectSerializer < ActiveModel::Serializer
  include SerializationHelper
  attributes :slug, :name, :image
end
