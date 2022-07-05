class ChangeStudyPlanCurrentStageToOffset < ActiveRecord::Migration[5.2]
  def change
    rename_column :study_plans, :current_stage, :offset
  end
end
