# frozen_string_literal: true

class Bff::User::Events::StudyPlansController < Bff::User::BffUserBaseController
  def index
    @adapter = Bff::Templates::StudyPlans::StudyPlanContent.new(current_user)
    return render_not_found unless @adapter.fetch_study_plan

    @adapter.fetch_contents(params[:page])
    render_results({ checked_events: @adapter.events })
  end

  def create
    @study_plan = StudyPlan.where(user: current_user, active: true).last
    StudyPlanNodeModule.where(node_module_id: params[:id], study_plan: @study_plan).update_all(completed: true)
    render_no_content
  end

  def destroy
    @study_plan = StudyPlan.where(user: current_user, active: true).last
    StudyPlanNodeModule.where(node_module_id: params[:id], study_plan: @study_plan).update_all(completed: false)
    render_no_content
  end
end
