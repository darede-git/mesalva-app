# frozen_string_literal: true

class Major < ActiveRecord::Base
  include AlgoliaSearch

  has_many :scholar_records
  has_and_belongs_to_many :colleges

  def college_names
    colleges.pluck(:name)
  end

  validates :name, presence: true, uniqueness: true

  algoliasearch auto_index: true, disable_indexing: Rails.env.test? do
    attributesForFaceting %w[name college_names]
    searchableAttributes %w[name college_names]
    attribute :name, :college_names
  end
end
