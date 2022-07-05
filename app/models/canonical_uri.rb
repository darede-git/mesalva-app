# frozen_string_literal: true

class CanonicalUri < ActiveRecord::Base
  include AlgoliaSearch
  validates :slug, presence: true, allow_blank: false, uniqueness: true
  validate :permalink_exists

  algoliasearch index_name: name.pluralize, disable_indexing: Rails.env.test? do
    attributesForFaceting %w[slug]
    attribute :id,
              :slug
  end

  def permalink_exists
    return unless Permalink.find_by_slug(slug).nil?

    errors.add(:permalink,
               I18n.t('activerecord.errors.models.permalink.not_found',
                      slug: slug))
  end
end
