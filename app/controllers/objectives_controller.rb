# frozen_string_literal: true

class ObjectivesController < ApplicationController
  include Cache
  before_action -> { authenticate(%w[admin teacher user]) }, only: [:index]
  before_action -> { authenticate(%w[admin]) }, only: %i[update destroy]
  before_action :set_objective, only: %i[update destroy]
  before_action :objectives, only: :index

  def index
    render_ok(@objectives) \
      if stale?(etag: @objectives.to_json,
                public: true,
                template: false,
                last_modified: last_update_for(@objectives))
  end

  def update
    if @objective.update(objective_params)
      render_ok(@objective)
    else
      render_unprocessable_entity(@objective.errors)
    end
  end

  def destroy
    @objective.destroy
    render_no_content
  end

  private

  def set_objective
    @objective = Objective.find(params[:id])
  end

  def objectives
    @objectives = Objective.active.order(:position)
  end

  def objective_params
    params.permit(:education_segment_slug, :name, :active)
  end

  def last_update
    Objective.maximum(:updated_at)
  end
end
