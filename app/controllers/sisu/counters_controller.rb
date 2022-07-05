# frozen_string_literal: true

class Sisu::CountersController < Sisu::BaseController
  before_action :set_sisu_institute

  def index
    render json: [], meta: meta, status: :ok
  end

  private

  def set_sisu_institute
    @sisu_institute =
      SisuInstitute.chances_by_state_ies_modality(state_initials,
                                                  course,
                                                  modality)
  end

  def meta
    { "institute-count" => count,
      "max-passing-score" => max_passing_score,
      "min-passing-score" => min_passing_score }
  end

  def count
    @sisu_institute.count
  end

  def max_passing_score
    @sisu_institute&.map { |s| s["passing_score"].to_f }&.max
  end

  def min_passing_score
    @sisu_institute&.map { |s| s["passing_score"].to_f }&.min
  end
end
