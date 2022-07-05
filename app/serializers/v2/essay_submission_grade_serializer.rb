# frozen_string_literal: true

class V2::EssaySubmissionGradeSerializer < V2::ApplicationSerializer
  belongs_to :essay_submission
  belongs_to :correction_style_criteria

  attribute :grade

  attribute :correction_style_criterium do |object|
    CorrectionStyleCriteriumSerializer.new(object.correction_style_criteria)
  end
end
