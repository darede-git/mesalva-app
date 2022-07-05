# frozen_string_literal: true

class CancellationQuizzesController < ApplicationController
  include IntercomHelper

  before_action -> { authenticate(%w[user]) }
  before_action :sanitize_parameters

  def create
    @cancellation_quiz = CancellationQuiz.new(cancellation_quiz_params)
    if @cancellation_quiz.save
      update_intercom_user(current_user, nps: nps_score_param)
      render_cancellation_quiz
    else
      render_unprocessable_entity(@cancellation_quiz.errors)
    end
  end

  private

  def nps_score_param
    params[:net_promoter_score_attributes][:score]
  end

  def render_cancellation_quiz
    render json: @cancellation_quiz,
           include: [:net_promoter_score],
           status: :created
  end

  def cancellation_quiz_params
    params
      .permit(:order_id, :user_id, quiz: {},
                                   net_promoter_score_attributes: %i[score
                                                                     reason])
      .merge(user_id: current_user.id)
      .to_unsafe_h
  end

  def sanitize_parameters
    params[:order_id] = order_id if params[:order_id].present?
  end

  def order_id
    Order.find_by_token(params[:order_id]).id
  end
end
