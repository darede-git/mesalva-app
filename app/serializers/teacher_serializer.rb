# frozen_string_literal: true

class TeacherSerializer < ActiveModel::Serializer
  include SerializationHelper

  attributes :uid, :name, :image, :email, :description, :birth_date, :active

  def id
    object.uid
  end
end
