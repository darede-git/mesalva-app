class ChangeDefaultValueToStudyPlanNodeModuleCompleted < ActiveRecord::Migration[4.2]
  def change
    change_column :study_plan_node_modules, :completed, :boolean, :default => false
  end
end
