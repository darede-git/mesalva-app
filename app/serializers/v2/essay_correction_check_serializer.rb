# frozen_string_literal: true

class V2::EssayCorrectionCheckSerializer < V2::ApplicationSerializer
  belongs_to :essay_submission

  attributes :checked, :correction_style_criteria_check_id
end
