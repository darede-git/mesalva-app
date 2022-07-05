# frozen_string_literal: true

class Quiz::QuestionsController < Quiz::BaseController
  private

  def quiz_entity_params
    params.permit(:quiz_form_id, :statement, :question_type, :description,
                  :position, :required)
  end

  def model
    Quiz::Question
  end
end
