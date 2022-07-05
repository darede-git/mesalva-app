class RenameStudyPlanEstimatedStagesToEstimatedWeeks < ActiveRecord::Migration[5.2]
  def change
    rename_column :study_plans, :estimated_stages, :estimated_weeks
  end
end
