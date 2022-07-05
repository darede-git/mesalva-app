class RemoveStudyPlanFormNodes < ActiveRecord::Migration[5.2]
  def change
    drop_table :study_plan_form_nodes
  end
end
