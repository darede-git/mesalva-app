class AddCompletedToStudyPlanNodeModule < ActiveRecord::Migration[4.2]
  def change
    add_column :study_plan_node_modules, :completed, :boolean, default: true
  end
end
