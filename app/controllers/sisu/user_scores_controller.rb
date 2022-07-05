# frozen_string_literal: true

require 'me_salva/sisu/scores'

class Sisu::UserScoresController < ApplicationController
  before_action -> { validate_user }

  def create
    @form_submission = Quiz::FormSubmission.new(form_submission_params)
    if @form_submission.save
      render json: @form_submission, status: :created, meta: meta
    else
      render_unprocessable_entity(@form_submission.errors.messages)
    end
  end

  private

  def user_id
    @user = current_user
    @user = User.find_by_uid(params[:partner_user_uid]) if @user.nil? && params[:partner_user_uid].present?
    @user = User.find_by_token(params[:partner_user_token]) if @user.nil? && params[:partner_user_token].present?
    @user.id
  end

  def validate_user
    render_unprocessable_entity(t('errors.messages.invalid_sisu_user_param')) \
    if current_user.nil? && params['partner_user_token'].nil?
  end

  def form_submission_params
    params.permit(:quiz_form_id, answers_attributes: answers_attributes)
          .merge(user_id: user_id)
  end

  def answers_attributes
    %i[quiz_question_id quiz_alternative_id value]
  end

  def scores
    MeSalva::Sisu::Scores.new(@form_submission, user_id)
  end

  def meta
    scores.results
  end
end
