# frozen_string_literal: true

class BaseExerciseAnswersSerializer < ActiveModel::Serializer
  attributes :results

  private

  def answers
    object.results
  end
end
