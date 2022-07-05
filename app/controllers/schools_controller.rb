# frozen_string_literal: true

class SchoolsController < ApplicationController
  before_action :set_school
  def show
    if @school
      render json: serialize(@school), status: :ok
    else
      render_not_found
    end
  end

  def set_school
    @school = School.find(params[:id])
  end
end
