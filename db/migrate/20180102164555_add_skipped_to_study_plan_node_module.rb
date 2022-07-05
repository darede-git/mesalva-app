class AddSkippedToStudyPlanNodeModule < ActiveRecord::Migration[4.2]
  def change
    add_column :study_plan_node_modules, :skipped, :boolean, default: false
  end
end
