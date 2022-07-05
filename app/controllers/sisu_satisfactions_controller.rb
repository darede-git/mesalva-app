# frozen_string_literal: true

class SisuSatisfactionsController < ApplicationController
  before_action -> { authenticate(%w[user]) }, only: :create

  def create
    sisu_satisfaction = SisuSatisfaction.new(sisu_satisfaction_params)
    if sisu_satisfaction.save
      render_created(sisu_satisfaction)
    else
      render_unprocessable_entity(sisu_satisfaction.errors)
    end
  end

  private

  def sisu_satisfaction_params
    params.merge(user_id: current_user.id)
          .permit(:satisfaction, :plan, :user_id)
  end
end
