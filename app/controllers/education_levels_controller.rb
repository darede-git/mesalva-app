# frozen_string_literal: true

class EducationLevelsController < ApplicationController
  include Cache
  before_action -> { authenticate(%w[admin teacher user]) }, only: [:index]
  before_action -> { authenticate(%w[admin]) }, only: %i[update destroy]
  before_action :set_education_level, only: %i[update destroy]
  before_action :education_levels, only: :index

  def index
    render_ok(@education_levels) \
      if stale?(etag: @education_levels,
                template: false,
                last_modified: last_update_for(@education_levels))
  end

  def update
    if @education_level.update(education_level_params)
      render_ok(@education_level)
    else
      render_unprocessable_entity(@education_level.errors)
    end
  end

  def destroy
    @education_level.destroy
    render_no_content
  end

  private

  def set_education_level
    @education_level = EducationLevel.find(params[:id])
  end

  def education_levels
    @education_levels = EducationLevel.all
  end

  def education_level_params
    params.permit(:name)
  end
end
