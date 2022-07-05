# frozen_string_literal: true

class Quiz::FormsController < Quiz::BaseController
  def show
    render json: @quiz_entity,
           status: :ok,
           serializer: Quiz::FormSerializer,
           include: '**'
  end

  private

  def quiz_entity_params
    params.permit(:name, :description, :active, :form_type)
  end

  def model
    Quiz::Form
  end
end
