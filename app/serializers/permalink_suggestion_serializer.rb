# frozen_string_literal: true

class PermalinkSuggestionSerializer < ActiveModel::Serializer
  attributes :slug, :suggestion_name, :suggestion_slug
end
