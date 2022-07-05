# frozen_string_literal: true

class Content::MediumSerializer < ActiveModel::Serializer
  attributes :slug, :medium_type, :options
end
