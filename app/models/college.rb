# frozen_string_literal: true

class College < ActiveRecord::Base
  include AlgoliaSearch

  has_many :scholar_records
  has_and_belongs_to_many :majors

  def major_names
    majors.pluck(:name)
  end

  validates :name, presence: true, uniqueness: true

  algoliasearch auto_index: true, disable_indexing: Rails.env.test? do
    attributesForFaceting %w[name major_names]
    searchableAttributes %w[name major_names]
    attribute :name, :major_names
  end
end
