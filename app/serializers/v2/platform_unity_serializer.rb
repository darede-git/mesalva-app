# frozen_string_literal: true

class V2::PlatformUnitySerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :slug, :uf, :city
end
