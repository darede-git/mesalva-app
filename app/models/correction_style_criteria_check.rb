# frozen_string_literal: true

class CorrectionStyleCriteriaCheck < ActiveRecord::Base
  belongs_to :correction_style_criteria
  has_many :essay_submission_grades
end
