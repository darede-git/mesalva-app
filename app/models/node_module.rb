# frozen_string_literal: true

require 'me_salva/permalinks/validator'

class NodeModule < ActiveRecord::Base
  include SlugHelper
  include RelativesPositionHelper
  include TextSearchHelper
  include CountersHelper
  include PermalinkValidationHelper
  include MediumTypeCounterQueries
  include SearchableEntityHelper
  include MetaTagsHelper
  include AlgoliaSearch

  validates :name, :slug, :node_module_type, presence: true, allow_blank: false
  validates_inclusion_of :node_module_type,
                         in: %w[default prep_test prep_test_tri prep_test_b2b]

  has_secure_token
  has_many :node_module_media, dependent: :destroy
  has_many :media, through: :node_module_media

  has_many :node_module_items, -> { order(position: :asc, id: :asc) },
           dependent: :destroy

  has_many :items, through: :node_module_items

  has_many :node_node_modules, dependent: :destroy
  has_many :nodes,
           through: :node_node_modules,
           after_remove: :remove_node_node_module_permalinks

  belongs_to :instructor, polymorphic: true

  has_many :permalinks, dependent: :destroy

  mount_base64_uploader :image, ContentImageUploader

  scope :active, -> { where active: true }
  scope :listed, -> { where listed: true }

  scope :by_node_token,  -> (node_token) { joins(:nodes).where({"nodes.token": node_token}) }

  scope :with_medium_counters_by_id, lambda { |node_module_ids|
    find_by_sql([node_module_medium_type_counters_query,
                 { node_module_ids: node_module_ids }])
      .as_json(only: %w[id counters])
  }

  algoliasearch index_name: name.pluralize,
                disable_indexing: Rails.env.test? do
    attribute :id,
              :name,
              :code,
              :description,
              :token,
              :suggested_to,
              :slug,
              :active,
              :listed,
              :instructor_type,
              :medium_ids,
              :relevancy,
              :position,
              :node_module_type,
              :color_hex,
              :options
    attribute :instructor_uid do
      instructor.present? ? instructor.uid : nil
    end
    attribute :image do
      image.url
    end
    attribute :items do
      item_ids
    end
  end

  def full_type
    "node_module_#{node_module_type}"
  end

  def active_children
    direct_children.listed.active
  end

  def direct_children
    items
  end

  def main_permalink
    direct_permalinks.last
  end

  def direct_permalinks
    Permalink
      .where("item_id IS NULL AND medium_id IS NULL")
      .where(node_module_id: id)
  end

  def seconds_duration
    0
  end

  def active_medium_count_by_medium_type
    defaults = Hash[Medium::ALLOWED_TYPES.map { |type| [type, 0] }]
    counters = related_active_items.includes(:media)
                                   .group(:medium_type)
                                   .count(:media)
    defaults.merge(counters)
  end

  def parents
    nodes.active.listed
  end

  def entity_type?(type)
    type === :node_module
  end
end
