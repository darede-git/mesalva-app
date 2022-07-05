# frozen_string_literal: true

class Mentoring < ActiveRecord::Base
  belongs_to :user
  belongs_to :content_teacher

  scope :scheduled, -> { where(status: STATUS[:scheduled]) }
  scope :by_user, -> (user) { where(user: user)}
  scope :next_only_filter, -> (next_only = true) {
    return nil unless next_only
    where('starts_at > NOW()')
  }

  validates :rating, inclusion: { in: [1, 2, 3, 4, 5] }, :allow_blank => true
  validates :user_id, presence: true
  validates :content_teacher_id, presence: true
end
