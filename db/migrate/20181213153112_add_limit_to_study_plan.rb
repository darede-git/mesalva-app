class AddLimitToStudyPlan < ActiveRecord::Migration[5.2]
  def change
    add_column :study_plans, :limit, :integer, default: 0
  end
end
