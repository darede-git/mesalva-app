# frozen_string_literal: true

class SearchDatum < ActiveRecord::Base
  include AlgoliaSearch

  belongs_to :permalink
  belongs_to :node
  belongs_to :node_module
  belongs_to :item

  def self.find_by_entity(entity)
    class_name = entity.class.name.underscore
    send("search_data_ends_with_#{class_name}", entity)
  end

  def inactive_permalink?
    return false if permalink.nil?

    return false if permalink.active

    true
  end

  def self.search_data_ends_with_permalink(entity)
    SearchDatum.where(permalink_id: entity.id)
  end

  def self.search_data_ends_with_node(entity)
    SearchDatum.where(node_id: entity.id,
                      item_id: nil,
                      node_module_id: nil,
                      medium_id: nil)
  end

  def self.search_data_ends_with_item(entity)
    SearchDatum.where(item_id: entity.id,
                      medium_id: nil)
  end

  def self.search_data_ends_with_node_module(entity)
    SearchDatum.where(node_module_id: entity.id,
                      item_id: nil,
                      medium_id: nil)
  end

  algoliasearch unless: :inactive_permalink?,
                index_name: name.pluralize,
                disable_indexing: Rails.env.test? do
    attributesForFaceting %w[education_segment
                             second_level_slug
                             entity
                             entity_type]
    searchableAttributes ['name', 'description', 'unordered(text)']
    customRanking ['desc(popularity)']
    attribute :name,
              :link,
              :description,
              :text,
              :attachment,
              :education_segment,
              :second_level_slug,
              :entity_type,
              :entity,
              :popularity,
              :free,
              :permalink_slug
  end
end
