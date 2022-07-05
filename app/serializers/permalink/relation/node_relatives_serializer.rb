# frozen_string_literal: true

class Permalink::Relation::NodeRelativesSerializer < ActiveModel::Serializer
  include SerializationHelper

  attributes :name,
             :slug,
             :image

  attribute :medium_count, key: 'medium-count'
  attribute :color_hex, key: 'color-hex'
  attribute :seconds_duration, key: 'seconds-duration'

  def medium_count
    counters = object.medium_count
    counters.delete(nil) if counters.key? nil
    counters.transform_keys(&:dasherize)
  end
end
