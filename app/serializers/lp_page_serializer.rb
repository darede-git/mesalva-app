# frozen_string_literal: true

class LpPageSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :slug, :schema, :data
end
