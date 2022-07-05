# frozen_string_literal: true

class StudyPlanStructureUpdateWorker
  include Sidekiq::Worker

  def perform
    ::StudyPlan.active.pluck(:id).each do |id|
      MeSalva::StudyPlan::Structure.new(study_plan_id: id).maintenance
    end
  end
end
