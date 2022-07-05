# frozen_string_literal: true

require 'me_salva/grid/answer_grid'

class Quiz::FormSubmissionsController < Quiz::BaseController
  skip_before_action :authenticate_admin

  before_action :authenticate_admin, only: [:index]
  before_action -> { authenticate(%w[user]) }, only: %i[create show
                                                        last_user_submission]
  before_action :form_submission, only: [:last_user_submission]

  def create
    @quiz_entity = Quiz::FormSubmission.new(quiz_entity_params)
    if @quiz_entity.save
      render_form_submission
    else
      render_unprocessable_entity(@quiz_entity.errors.messages)
    end
  end

  def last_user_submission
    if @form_submission.present?
      render json: @form_submission.last, status: :ok, include: :answers
    else
      render_not_found
    end
  end

  private

  def quiz_entity_params
    params.permit(:quiz_form_id, answers_attributes: answers_attributes)
          .merge(user_id: current_user.id)
  end

  def answers_attributes
    %i[quiz_question_id quiz_alternative_id value]
  end

  def model
    Quiz::FormSubmission
  end

  def answer_grid?
    @quiz_entity.form.form_type == 'answer_grid'
  end

  def client
    @client ||= MeSalva::Grid::AnswerGrid.new(@quiz_entity, current_user.id)
  end

  def answer_grid
    client.check
  end

  def answer_grid_exists?
    client.file_exists?
  end

  def form_submission
    @form_submission = Quiz::FormSubmission.by_form_and_user(params[:form_id],
                                                             current_user.id)
  end

  def render_form_submission
    return render_created(@quiz_entity) unless answer_grid?

    return render_unprocessable_grid unless answer_grid_exists?

    render json: @quiz_entity, status: :created, meta: answer_grid,
           serializer: Quiz::FormSubmissionSerializer
  end

  def render_unprocessable_grid
    render_unprocessable_entity(t('errors.messages.not_found_answer_grid'))
  end
end
