# frozen_string_literal: true

class User::Dashboards::EvolutionSerializer < BaseExerciseAnswersSerializer
  attributes :results

  def results
    object
  end
end
