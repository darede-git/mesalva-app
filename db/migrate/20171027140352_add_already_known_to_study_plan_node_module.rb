class AddAlreadyKnownToStudyPlanNodeModule < ActiveRecord::Migration[4.2]
  def change
    add_column :study_plan_node_modules, :already_known, :boolean, default: false
  end
end
