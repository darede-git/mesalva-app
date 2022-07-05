# frozen_string_literal: true

class CorrectionStyle < ActiveRecord::Base
  has_many :essay_submissions
  has_many :correction_style_criterias

  scope :active, -> { where active: true }
end
