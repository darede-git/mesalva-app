# frozen_string_literal: true

class CorrectionStyleSerializer < ActiveModel::Serializer
  has_many :correction_style_criterias

  attributes :id, :name, :leadtime
end
