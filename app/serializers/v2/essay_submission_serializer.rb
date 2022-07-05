# frozen_string_literal: true

class V2::EssaySubmissionSerializer < V2::ApplicationSerializer
  set_id :token
  belongs_to :user, id_method_name: :user_uid
  belongs_to :correction_style
  has_many :essay_marks
  has_many :essay_submission_grades

  attributes :active, :grades, :valuer_uid, :feedback, :created_at, :leadtime,
             :updated_at, :correction_type, :uncorrectable_message, :appearance,
             :grade_final, :updated_by_uid, :rating, :draft, :draft_feedback,
             :send_date

  attribute :status, &:status_humanize

  attribute :essay do |object|
    object.essay.serializable_hash
  end

  attribute :corrected_essay do |object|
    object.corrected_essay.serializable_hash
  end

  attribute :permalink_slug do |object|
    object.permalink.slug
  end

  attribute :item_name do |object|
    object.permalink.item_name
  end

  attribute :medium_options do |object|
    object.permalink.medium.options
  end
end
