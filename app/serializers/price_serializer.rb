# frozen_string_literal: true

class PriceSerializer < ActiveModel::Serializer
  attributes :id, :value, :price_type, :currency
end
