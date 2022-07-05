class AddStageOrderToStudyPlanNodeModule < ActiveRecord::Migration[4.2]
  def change
    add_column :study_plan_node_modules, :stage_order, :integer
  end
end
