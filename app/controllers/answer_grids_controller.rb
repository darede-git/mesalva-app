# frozen_string_literal: true

class AnswerGridsController < ApplicationController
  before_action -> { authenticate(%w[user]) }
  before_action :set_answer_grid, only: [:index]

  def index
    render json: @answer_grid, status: :ok, include: :answers
  end

  private

  def set_answer_grid
    @answer_grid = Enem::AnswerGrid
                   .distinct_on_exam_by_user_and_year(current_user.id,
                                                      params['year'])
  end
end
