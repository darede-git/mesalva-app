# frozen_string_literal: true

require 'me_salva/permalinks/validator'

class Medium < ActiveRecord::Base
  include SlugHelper
  include PermalinkValidationHelper
  include TokenHelper
  include TextSearchHelper
  include AlgoliaSearch

  ALLOWED_TYPES = %w[text comprehension_exercise streaming
                     fixation_exercise video pdf essay public_document
                     soundcloud typeform book essay_video correction_video].freeze

  EXERCISE_LIMIT_BYTE_SIZE = 24000

  validates :name, :medium_type, presence: true, allow_blank: false

  validate :exercise_answers, :exercise_size, if: :exercise?

  validates  :audit_status,
             inclusion: { in: %w[reviewed revision_pending
                                 adjusts_pending] },
             presence: true,
             if: :exercise?

  validates :seconds_duration, presence: true, allow_blank: false, if: :video?

  validates :slug, uniqueness: true

  validates_inclusion_of :medium_type, in: ALLOWED_TYPES

  validates_numericality_of :difficulty, greater_than: 0,
                                         less_than_or_equal_to: 5,
                                         allow_blank: true

  has_secure_token
  has_many :comments, as: :commentable
  has_many :item_media, dependent: :destroy
  has_many :items, through: :item_media

  has_many :node_media, dependent: :destroy
  has_many :nodes, through: :node_media

  has_many :node_module_media, dependent: :destroy
  has_many :node_modules, through: :node_module_media

  has_many :permalinks, dependent: :destroy
  has_many :answers, -> { order(id: :asc) }, dependent: :destroy
  has_many :essay_submissions
  accepts_nested_attributes_for :answers

  mount_base64_uploader :attachment, AttachmentUploader

  mount_base64_uploader :placeholder, ImageUploader

  scope :active, -> { where active: true }
  scope :listed, -> { where listed: true }

  algoliasearch index_name: name.pluralize,
                disable_indexing: Rails.env.test? do
    attributesForFaceting %w[medium_type tag audit_status id]
    attribute :id,
              :name,
              :token,
              :description,
              :correction,
              :code,
              :slug,
              :medium_type,
              :active,
              :listed,
              :provider,
              :video_id,
              :pdf_url,
              :tag,
              :audit_status,
              :options

    attribute :medium_text do
      medium_text[0..1000] unless medium_text.nil?
    end
    attribute :answers do
      answers.pluck(:id, :text, :correct)
    end
  end

  def correct_answer_id
    return nil unless exercise?

    answers.select { |answer| answer['correct'] == true }.first.id
  end

  def exercise?
    medium_type.in?(%w[comprehension_exercise fixation_exercise])
  end

  def video?
    medium_type.in?(%w[video essay_video correction_video])
  end

  def streaming?
    medium_type == 'streaming'
  end

  def public_document?
    medium_type == 'public_document'
  end

  def full_type
    "medium_#{medium_type}"
  end

  def main_permalink
    direct_permalinks.last
  end

  def direct_permalinks
    Permalink.where({ medium_id: id })
  end

  def active_children
    []
  end

  def direct_children
    []
  end

  def entity_type?(type)
    type === :medium
  end

  def parents
    items.active.listed
  end

  private

  def exercise_answers
    errors.add(:message, 'Exercises must have 5 answers') unless answers?
    return if one_correct_answer?

    errors.add(:message, 'Exercises must have 1 correct answer')
  end

  def exercise_size
    errors.add(:exercise_byte_size, :invalid_size) unless valid_exercise_size?
  end

  def one_correct_answer?
    answers.map(&:correct).count(true) == 1
  end

  def answers?
    answers.size == 5
  end

  def pdf_url
    attachment.url
  end

  def exercise_byte_size
    [medium_text, correction, answers.join].join.bytesize
  end

  def valid_exercise_size?
    exercise_byte_size <= EXERCISE_LIMIT_BYTE_SIZE
  end

  def set_slug
    return generate_token(column: :slug) if public_document?

    super
  end
end

