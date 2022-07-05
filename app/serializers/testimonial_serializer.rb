# frozen_string_literal: true

class TestimonialSerializer < ActiveModel::Serializer
  include SerializationHelper

  attributes :text, :user_name, :avatar, :created_at, :id,
             :created_by, :updated_by, :education_segment_slug

  def id
    object.token
  end
end
