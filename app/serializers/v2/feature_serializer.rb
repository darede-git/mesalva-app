# frozen_string_literal: true

class V2::FeatureSerializer < V2::ApplicationSerializer
  attributes :id, :name, :slug, :token, :category
end
