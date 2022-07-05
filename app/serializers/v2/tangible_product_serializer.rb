# frozen_string_literal: true

class V2::TangibleProductSerializer < V3::BaseSerializer
  attributes :name, :height, :length, :width, :weight, :description, :sku, :image
end
