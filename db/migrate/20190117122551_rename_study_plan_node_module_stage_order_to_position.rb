class RenameStudyPlanNodeModuleStageOrderToPosition < ActiveRecord::Migration[5.2]
  def change
    rename_column :study_plan_node_modules, :stage_order, :position
  end
end
