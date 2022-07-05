# frozen_string_literal: true

class ScholarRecord < ActiveRecord::Base
  belongs_to :user
  belongs_to :major
  belongs_to :school
  belongs_to :college

  validates :user, presence: true, allow_blank: false
  validate :only_college_or_school_is_present
  validates :major, presence: { if: -> { college.present? } }

  scope :active, -> { where active: true }

  scope :by_user, lambda { |user|
    where(user: user).active
  }

  private

  def only_college_or_school_is_present
    add_base_errors unless only_one_is_present
  end

  def add_base_errors
    errors.add(:base, 'Specify a college or a school, not both')
  end

  def only_one_is_present
    school.blank? ^ college.blank?
  end
end
