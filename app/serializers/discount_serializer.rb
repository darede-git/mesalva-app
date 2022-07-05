# frozen_string_literal: true

class DiscountSerializer < ActiveModel::Serializer
  attributes :name, :percentual, :description, :code

  def id
    object.token
  end
end
