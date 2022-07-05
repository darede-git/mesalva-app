# frozen_string_literal: true

class ObjectiveSerializer < ActiveModel::Serializer
  attributes :id, :name, :education_segment_slug
end
