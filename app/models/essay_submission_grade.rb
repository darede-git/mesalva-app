# frozen_string_literal: true

class EssaySubmissionGrade < ActiveRecord::Base
  belongs_to :essay_submission
  belongs_to :correction_style_criteria
end
