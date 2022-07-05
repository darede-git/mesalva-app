# frozen_string_literal: true

class PermalinkSuggestion < ActiveRecord::Base
  validates :slug, :suggestion_slug, :suggestion_name, presence: true,
                                                       allow_blank: false
end
