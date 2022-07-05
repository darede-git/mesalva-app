class AddActiveToStudyPlans < ActiveRecord::Migration[4.2]
  def change
    add_column :study_plans, :active, :boolean, default: true
    StudyPlan.update_all(active: true)
  end
end
