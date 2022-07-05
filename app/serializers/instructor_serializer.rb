# frozen_string_literal: true

class InstructorSerializer < ActiveModel::Serializer
  include SerializationHelper

  attributes :uid, :name, :image, :description

  def id
    object.uid
  end
end
