# frozen_string_literal: true

class V2::PriceSerializer < V2::ApplicationSerializer
  attributes :value, :price_type, :currency
end
