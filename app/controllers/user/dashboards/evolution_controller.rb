# frozen_string_literal: true

class User::Dashboards::EvolutionController < ApplicationController
  before_action -> { authenticate(%w[user]) }

  def index
    render json: user_consumption,
           serializer: User::Dashboards::EvolutionSerializer,
           adapter: :attributes
  end

  private

  def user_consumption
    { } # TODO adicionar novo UserCounters
  end

  def period_type
    params[:period_type] || :year
  end
end
