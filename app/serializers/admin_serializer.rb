# frozen_string_literal: true

class AdminSerializer < ActiveModel::Serializer
  include SerializationHelper

  attributes :uid, :name, :image, :email, :description, :birth_date, :active,
             :role

  def id
    object.uid
  end
end
