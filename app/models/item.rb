# frozen_string_literal: true

require 'me_salva/permalinks/validator'
class Item < ActiveRecord::Base
  include SlugHelper
  include CountersHelper
  include RelativesPositionHelper
  include PermalinkValidationHelper
  include TokenHelper
  include SearchableEntityHelper
  include MediumTypeCounterQueries
  include MetaTagsHelper
  include TextSearchHelper
  include AlgoliaSearch

  before_validation :generate_chat_token, on: :create, if: :streaming?

  ALLOWED_TYPES = %w[video fixation_exercise essay book
                     text prep_test streaming public_document
                     essay_video correction_video].freeze
  ALLOWED_STREAMING_STATUSES = %w[scheduled streaming recorded].freeze

  validates :name, :slug, presence: true, allow_blank: false
  validates :active, :free, :listed, inclusion: { in: [true, false] }
  validates :item_type, inclusion: { in: ALLOWED_TYPES }

  with_options if: :streaming? do
    validates :streaming_status, presence: true,
                                 inclusion: { in: ALLOWED_STREAMING_STATUSES }
    validates :chat_token, presence: true
    validates :starts_at, presence: true
    validates :ends_at, presence: true
  end

  with_options if: :public_document? do
    validates :public_document_info, presence: true
    validates :description, :created_by, presence: true, allow_blank: false
  end

  with_options if: :not_public_document? do
    validates :public_document_info, absence: true
  end

  has_secure_token
  has_many :item_media, -> { order(position: :asc, id: :asc) },
           dependent: :destroy
  has_many :media, through: :item_media
  has_many :content_teacher_items
  has_many :content_teachers, through: :content_teacher_items
  has_many :node_module_items, dependent: :destroy
  has_many :node_modules, through: :node_module_items
  has_many :permalinks, dependent: :destroy

  has_one :public_document_info, dependent: :destroy
  has_one :tri_reference

  accepts_nested_attributes_for :public_document_info

  scope :active, -> { where active: true }
  scope :listed, -> { where listed: true }

  scope :live_classes_of_the_day, lambda { |date|
    where("starts_at >= ?", MeSalva::DateHelper.beginning_of_day(date))
      .where("ends_at <= ?", MeSalva::DateHelper.end_of_day(date))
      .where(item_type: 'streaming')
  }

  scope :with_medium_counters_by_id, lambda { |item_ids|
    find_by_sql([item_medium_type_counters_query,
                 { item_ids: item_ids }])
      .as_json(only: %w[id counters])
  }

  scope :by_user_access, lambda { |user_id|
    joins(:node_module_items)
      .joins('INNER JOIN node_node_modules ON
        node_node_modules.node_module_id = node_module_items.node_module_id')
      .joins('INNER JOIN nodes_packages ON nodes_packages.node_id = node_node_modules.node_id')
      .joins('INNER JOIN accesses ON accesses.package_id = nodes_packages.package_id')
      .where('accesses.active = TRUE')
      .where('accesses.expires_at > now()')
      .where('accesses.user_id = ?', user_id)
  }

  algoliasearch index_name: name.pluralize, disable_indexing: Rails.env.test? do
    attributesForFaceting %w[item_type tag]
    attribute :id, :name, :description, :code, :slug, :item_type,
              :active, :listed, :tag, :free, :streaming_status, :options,
              :token, :starts_at, :content_teacher_slugs, :ends_at
    attribute :media do
      medium_ids
    end
    attribute :reviewed_media do
      exercises_count_by('reviewed')
    end
    attribute :revision_pending_media do
      exercises_count_by('revision_pending')
    end
    attribute :adjusts_pending_media do
      exercises_count_by('adjusts_pending')
    end
  end

  def content_teacher_slugs
    content_teachers.map(&:slug)
  end

  def content_teacher_slugs=(content_teacher_slugs)
    self.content_teachers = ContentTeacher.where(slug: content_teacher_slugs)
  end

  def seconds_duration
    media.where('medium_type = ?', 'video').sum(:seconds_duration)
  end

  def active_medium_count_by_medium_type
    related_active_media.group(:medium_type).count(:media)
  end

  def exercises_count_by(status)
    media.where(audit_status: status).count
  end

  def streaming?
    item_type == 'streaming'
  end

  def public_document?
    item_type == 'public_document'
  end

  def not_public_document?
    item_type != 'public_document'
  end

  def generate_chat_token
    generate_token(column: :chat_token)
  end

  def full_type
    "item_#{item_type}"
  end

  def active_children
    direct_children.listed.active
  end

  def direct_children
    media
  end

  def main_permalink
    direct_permalinks.last
  end

  def direct_permalinks
    Permalink.where("medium_id IS NULL").where(item_id: id)
  end

  def entity_type?(type)
    type === :item
  end

  def parents
    node_modules.active.listed
  end

  private

  def set_slug
    return generate_token(column: :slug) if public_document?

    super
  end
end
