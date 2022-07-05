# frozen_string_literal: true

class EssayCorrectionCheck < ActiveRecord::Base
  belongs_to :correction_style_criteria_check
  belongs_to :essay_submission
end
