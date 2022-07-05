# frozen_string_literal: true

class Quiz::AlternativesController < Quiz::BaseController
  private

  def quiz_entity_params
    params.permit(:quiz_question_id, :description, :value)
  end

  def model
    Quiz::Alternative
  end
end
