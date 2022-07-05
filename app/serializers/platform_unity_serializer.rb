# frozen_string_literal: true

class PlatformUnitySerializer < ActiveModel::Serializer
    attributes :name, :slug, :uf, :city
end