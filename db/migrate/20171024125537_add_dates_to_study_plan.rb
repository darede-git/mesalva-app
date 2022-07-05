class AddDatesToStudyPlan < ActiveRecord::Migration[4.2]
  def change
    add_column :study_plans, :start_date, :datetime
    add_column :study_plans, :end_date, :datetime
  end
end
