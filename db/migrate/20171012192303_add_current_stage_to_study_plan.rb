class AddCurrentStageToStudyPlan < ActiveRecord::Migration[4.2]
  def change
    add_column :study_plans, :current_stage, :integer, default: 1
  end
end
