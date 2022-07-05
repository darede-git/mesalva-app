# frozen_string_literal: true

class Content::Relation::NodeRelativesSerializer < ActiveModel::Serializer
  include SerializationHelper

  has_many :media, serializer: Content::Relation::NodeMediumSerializer

  attributes :name, :slug, :image, :options

  attribute :node_type, key: 'node-type'
  attribute :color_hex, key: 'color-hex'
end
