# frozen_string_literal: true

class Quiz::AnswerSerializer < ActiveModel::Serializer
  belongs_to :question
  belongs_to :alternative
  belongs_to :form_submission

  attributes :quiz_alternative_id, :value, :quiz_question_id
end
