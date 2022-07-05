# frozen_string_literal: true

class Sisu::CoursesController < Sisu::BaseController
  def show
    render json: [], meta: meta, status: :ok
  end

  private

  def meta
    SisuInstitute.courses_by_state(params[:uf])
  end
end
