# frozen_string_literal: true

class Sisu::InstitutesController < Sisu::BaseController
  before_action -> { authenticate(%w[user]) }
  before_action :set_sisu_institute

  def index
    render_ok(@sisu_institute)
  end

  private

  def set_sisu_institute
    @sisu_institute = SisuInstitute.where(course: course,
                                          state: state_initials,
                                          modality: modality,
                                          year: ENV['SISU_YEAR'],
                                          semester: ENV['SISU_SEMESTER'])
  end
end
