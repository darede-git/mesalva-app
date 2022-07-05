# frozen_string_literal: true

require 'me_salva/permalinks/validator'

class Node < ActiveRecord::Base
  include SlugHelper
  include NodeModuleCountHelper
  include RelativesPositionHelper
  include PositionHelper
  include CountersHelper
  include TextSearchHelper
  include PermalinkValidationHelper
  include SearchableEntityHelper
  include MetaTagsHelper
  include AlgoliaSearch

  STUDY_TOOLS = %w[prep_test lecture essay live public_document
                   test_repository_group emotional_support].freeze

  BASIC_NODE_TYPES = %w[area course cycle department education_segment
                        study_plan subject year concourse test_repository
                        chapter chapter_type library area_subject
                        lecture_class specific_subject basic_subject
                        public_document_university].freeze

  NODE_TYPES = BASIC_NODE_TYPES + STUDY_TOOLS

  validates :name, :slug, :node_type, presence: true, allow_blank: false
  validates_inclusion_of :node_type, in: NODE_TYPES
  validates_presence_of :color_hex, if: :color_required?

  has_secure_token
  has_many :node_node_modules, -> { order(position: :asc, id: :asc) },
           dependent: :destroy

  has_many :node_modules, through: :node_node_modules,
                          after_remove: :remove_node_node_module_permalinks

  has_many :node_media, dependent: :destroy
  has_many :media, through: :node_media

  has_many :permalink_nodes, dependent: :destroy
  has_many :permalinks, through: :permalink_nodes, dependent: :destroy

  has_and_belongs_to_many :packages

  mount_base64_uploader :image, ContentImageUploader

  has_ancestry orphan_strategy: :rootify

  scope :active, -> { where active: true }

  scope :listed, -> { where listed: true }

  scope :without_study_tools, -> { where.not(node_type: STUDY_TOOLS) }

  algoliasearch index_name: name.pluralize, disable_indexing: Rails.env.test? do
    attributesForFaceting %w[node_type parent_id]
    attribute :id,
              :name,
              :description,
              :token,
              :suggested_to,
              :slug,
              :node_type,
              :active,
              :listed,
              :color_hex,
              :position,
              :video,
              :parent_id,
              :medium_ids,
              :options
    attribute :image do
      image.url
    end
    attribute :children do
      has_children? ? child_ids : node_module_ids
    end
    attribute :children_type do
      has_children? ? 'node' : 'node_module'
    end
    attribute :parents do
      ancestry? ? ancestors_slug : nil
    end
  end

  def id_and_name
    "#{id} - #{name}"
  end

  def self.education_segments
    where(ancestry: 1, active: true, node_type: 'education_segment')
      .order(:position)
  end

  def self.education_segment_by_slug(education_segment_slug)
    education_segments.find_by_slug(education_segment_slug)
  end

  def seconds_duration
    0
  end

  def medium_count
    medium_count_from_query
  end

  def children
    super.order(:position)
  end

  def subtree
    super.order(:position)
  end

  def parents
    [parent]
  end

  def last_child_position
    children.pluck(:position).last
  end

  def education_segment?
    node_type == 'education_segment'
  end

  def live?
    node_type == 'live'
  end

  def public_document?
    node_type == 'public_document'
  end

  def full_type
    "node_#{node_type}"
  end

  def main_permalink
    direct_permalinks.last
  end

  def direct_permalinks
    Permalink.joins(:permalink_nodes)
             .where("node_module_id IS NULL AND item_id IS NULL AND medium_id IS NULL")
             .where("slug LIKE ?", ["%#{slug}"])
             .where({ "permalink_nodes.node_id": id })
  end

  def direct_children
    all_children = node_modules.to_a
    all_children.concat(children.to_a)
  end

  def active_children
    all_children = node_modules.listed.active.to_a
    all_children.concat(children.listed.active.to_a)
  end

  def entity_type?(type)
    type === :node
  end

  private

  def color_required?
    %w[area subject].include? node_type
  end

  def ancestors_slug
    ancestors.map(&:slug)[1..-1].join('/')
  end
end
