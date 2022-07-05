# frozen_string_literal: true

class School < ActiveRecord::Base
  include AlgoliaSearch

  has_many :scholar_records

  validates :name, presence: true, uniqueness: true

  algoliasearch auto_index: true, disable_indexing: Rails.env.test? do
    attributesForFaceting %w[name]
    searchableAttributes %w[name]
    attribute :uf, :city, :name
  end
end
