# frozen_string_literal: true

class FaqSerializer < ActiveModel::Serializer
  has_many :questions

  attributes :id, :name,
             :created_by, :updated_by

  def id
    object.token
  end
end
