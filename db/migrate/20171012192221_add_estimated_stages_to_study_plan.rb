class AddEstimatedStagesToStudyPlan < ActiveRecord::Migration[4.2]
  def change
    add_column :study_plans, :estimated_stages, :integer
  end
end
