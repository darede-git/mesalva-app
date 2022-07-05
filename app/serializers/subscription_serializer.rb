# frozen_string_literal: true

class SubscriptionSerializer < ActiveModel::Serializer
  attributes :active

  def id
    object.token
  end
end
