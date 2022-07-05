# frozen_string_literal: true

class PlatformSerializer < ActiveModel::Serializer
    attributes :name, :slug, :domain, :unity_types
end
