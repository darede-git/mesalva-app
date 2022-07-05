# frozen_string_literal: true

class Permalink::PermalinkSerializer < ActiveModel::Serializer
  attributes :id, :slug, :canonical_uri
end
