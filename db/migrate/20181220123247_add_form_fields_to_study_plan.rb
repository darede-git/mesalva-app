class AddFormFieldsToStudyPlan < ActiveRecord::Migration[5.2]
  def change
    add_column :study_plans, :subject_ids, :integer, array: true, default: []
    add_column :study_plans, :shifts, :json, default: {}
    add_column :study_plans, :available_time, :integer, default: 0
    add_column :study_plans, :keep_completed_modules, :boolean, default: true
  end
end
