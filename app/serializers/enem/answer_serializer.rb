# frozen_string_literal: true

class Enem::AnswerSerializer < ActiveModel::Serializer
  attributes :question_id, :value, :correct_value, :alternative_id,
             :correct

  def question_id
    object.question.id
  end

  def alternative_id
    object.alternative.id
  end
end
