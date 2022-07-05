# frozen_string_literal: true

class CorrectionStyleCriteriumSerializer < ActiveModel::Serializer
  has_many :correction_style_criteria_checks, serializer: CorrectionStyleCriteriumCheckSerializer
  attributes :id, :name, :description, :values, :max_grade, :position, :video_id
end
