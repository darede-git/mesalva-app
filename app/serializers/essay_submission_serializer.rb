# frozen_string_literal: true

class EssaySubmissionSerializer < ActiveModel::Serializer
  attributes :id, :active, :grades, :valuer_uid, :feedback, :created_at,
             :leadtime, :updated_at, :correction_type, :uncorrectable_message,
             :appearance, :grade_final, :updated_by_uid, :rating, :draft,
             :draft_feedback, :status, :essay, :corrected_essay,
             :permalink_slug, :item_name, :send_date, :deadline_at

  belongs_to :user, foreign_key: :uid
  belongs_to :correction_style
  has_many :comments
  has_many :essay_marks

  def permalink_slug
    object.permalink.slug
  end

  def item_name
    name = object.permalink.item_name
    return name unless name.nil?
    Item.find(object.permalink.item_id).name unless object.permalink.item_id.nil?
  end

  def essay
    object.essay.serializable_hash
  end

  def corrected_essay
    object.corrected_essay.serializable_hash
  end

  def id
    object.token
  end

  def status
    object.status_humanize
  end

  def valuer_uid
    object.valuer_uid
  end
end
