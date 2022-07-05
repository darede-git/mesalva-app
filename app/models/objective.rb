# frozen_string_literal: true

class Objective < ActiveRecord::Base
  has_many :users
  validates :name, presence: true, allow_blank: false, uniqueness: true

  scope :active, -> { where active: true }

  scope :with_education_slug, -> { where.not education_segment_slug: nil }
end
