# frozen_string_literal: true

class CorrectionStyleCriteria < ActiveRecord::Base
  belongs_to :correction_style
  has_many :correction_style_criteria_checks
end
