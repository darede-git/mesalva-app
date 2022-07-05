# frozen_string_literal: true

class Enem::AnswerGridSerializer < ActiveModel::Serializer
  has_many :answers
  attributes :exam, :color, :language, :year
end
