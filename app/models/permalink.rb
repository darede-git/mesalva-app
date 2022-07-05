# frozen_string_literal: true

class Permalink < ActiveRecord::Base
  include AlgoliaSearch
  include SearchableEntityHelper

  validate :canonical_uri_existence
  validates :slug, presence: true, allow_blank: false
  validates_uniqueness_of :slug

  has_many :permalinks
  belongs_to :permalink

  has_many :permalink_nodes
  has_many :nodes, -> { active }, through: :permalink_nodes, dependent: :destroy
  belongs_to :node_module, -> { active }, touch: true
  belongs_to :item, -> { active }, touch: true
  belongs_to :medium, -> { active }, touch: true

  scope :with_ordered_entities, lambda {
    eager_load(:nodes, :node_module, :item, :medium)
      .order('permalink_nodes.position')
  }

  scope :node_permalinks_by_slug,
        lambda { |slug|
          node_permalinks.where('slug = ?', slug)
        }

  scope :node_permalinks,
        lambda {
          where('node_module_id IS NULL '\
            'AND item_id IS NULL AND medium_id IS NULL')
        }

  scope :with_permalink_nodes_by_slug,
        lambda { |slug|
          joins(
            'LEFT JOIN permalink_nodes ON '\
            'permalinks.id = permalink_nodes.permalink_id'
          ).where('slug = ?', slug)
        }

  scope :by_slug, ->(slug) { where(slug: slug) }
  scope :usefull_columns, lambda {
    select(:id, :slug, :node_module_id, :item_id, :medium_id)
  }
  scope :ending_with_slug, lambda { |slug|
    usefull_columns.where('slug like ?', "%/#{slug}")
  }
  scope :ending_with_or_equal_slug, lambda { |slug|
    usefull_columns.where('slug like ? OR slug = ?', "%/#{slug}", slug.to_s)
  }

  algoliasearch if: :under_enem_e_vestibulares,
                index_name: name.pluralize,
                disable_indexing: Rails.env.test? do
    attributesForFaceting %w[slug canonical_uri]
    attribute :id,
              :slug,
              :canonical_uri
  end

  def self.find_by_slug_with_ordered_entities(slug)
    with_ordered_entities.find_by_slug(slug)
  end

  def self.find_by_slug_with_active_entities(slug)
    permalink = find_by_slug_with_ordered_entities(slug)
    return unless permalink

    permalink if permalink.active
  end

  def item_slug
    item&.slug
  end

  def item_type
    item&.item_type
  end

  def ends_with_medium?
    medium_id.present?
  end

  def with_item?
    item_id.present?
  end

  def medium_seconds_duration
    medium&.seconds_duration
  end

  def entities
    @entities = []
    [nodes, node_module, item, medium].each do |entity|
      push_entity(entity) unless entity.nil?
    end
    @entities.flatten!
    return [] unless valid_content?

    @entities
  end

  def active
    entities.any?
  end

  def ends_with_video_medium?
    medium.try(:medium_type) == 'video'
  end

  def ends_with_text_medium?
    medium.try(:medium_type) == 'text'
  end

  def essay_medium?
    medium.try(:medium_type) == 'essay'
  end

  def ends_with_exercise_medium?
    %w[fixation_exercise comprehension_exercise]
      .include? medium.try(:medium_type)
  end

  def viewable_to_guests?
    return true if inconditional_valid_medium?

    return true if viewable_free_medium?

    return viewable_streaming? if streaming?

    false
  end

  def inconditional_valid_medium?
    %w[comprehension_exercise fixation_exercise essay]
      .include?(medium.try(:medium_type))
  end

  def viewable_free_medium?
    %w[text public_document]
      .include?(medium.try(:medium_type)) && item.free
  end

  def streaming?
    medium.try(:medium_type) == 'streaming'
  end

  def viewable_streaming?
    %w[scheduled streaming].include?(item.try(:streaming_status)) && item.free
  end

  def medium_correct_answer?(answer_id)
    return nil unless ends_with_exercise_medium?

    medium.correct_answer_id.to_s == answer_id.to_s
  end

  def medium_correct_answer_id
    medium.correct_answer_id
  end

  def item_name
    item&.try(:name)
  end

  def node_module_name
    node_module&.try(:name)
  end

  def free_item?
    item&.free
  end

  def last_node_id
    nodes.last.id
  end

  def first_node
    nodes&.first
  end

  def education_segment_slug
    first_node&.slug
  end

  def under_enem_e_vestibulares
    education_segment_slug == 'enem-e-vestibulares'
  end

  private

  def push_entity(entity)
    return @entities << entity_mapper(entity) if entity.respond_to? :map

    @entities << entity_fields(entity)
  end

  def entity_mapper(entity)
    entity.map do |n|
      n.instance_of?(Node) ? node_entity_fields(n) : entity_fields(n)
    end
  end

  def entity_fields(e)
    {
      id: e.id, name: e.name, slug: e.slug, entity_type: e.class.to_s.underscore
    }
  end

  def node_entity_fields(e)
    {
      id: e.id,
      name: e.name,
      slug: e.slug,
      color_hex: e.color_hex,
      entity_type: e.class.to_s.underscore,
      node_type: e.node_type
    }
  end

  def valid_content?
    return unless @entities.any?

    content_struct.all? do |content|
      unique_entities.include?(content)
    end
  end

  def unique_entities
    @entities.map { |e| e[:entity_type] }.uniq
  end

  def content_struct
    struct = %w[node node_module item medium]
    index = struct.find_index(unique_entities.last)
    struct.take(index + 1)
  end

  def canonical_uri_existence
    return if canonical_uri.nil?

    return if CanonicalUri.find_by_slug(canonical_uri).present?

    errors.add(:permalink, I18n.t('canonicals.not_found', slug: slug))
  end
end
