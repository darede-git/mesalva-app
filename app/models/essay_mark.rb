# frozen_string_literal: true

class EssayMark < ActiveRecord::Base
  belongs_to :essay_submission

  ALLOWED_TYPES = %w[ortografia regencia semantica concordancia
                     pontuacao falha_sintatica paralelismo diverso].freeze

  validates :description, :essay_submission, :coordinate,
            presence: true, allow_blank: false
  validates :mark_type, inclusion: { in: ALLOWED_TYPES }, presence: true
end
