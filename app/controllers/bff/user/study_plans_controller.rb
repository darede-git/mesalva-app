# frozen_string_literal: true

class Bff::User::StudyPlansController < Bff::User::BffUserBaseController
  def show
    @adapter = Bff::Templates::StudyPlans::StudyPlanContent.new(current_user)
    return render_results(@adapter.empty_study_plan) unless @adapter.fetch_study_plan

    @adapter.fetch_contents(params[:page])
    render_results(@adapter.render)
  end
end
