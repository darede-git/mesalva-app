class AddFieldsToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :origin, :string
    add_column :users, :agenda, :string
    add_column :users, :current_school, :string
    add_column :users, :current_school_courses, :string
    add_column :users, :desired_courses, :string
    add_column :users, :school_appliances, :string
    add_column :users, :school_appliance_this_year, :string
    add_column :users, :favorite_school_subjects, :string
    add_column :users, :difficult_learning_subjects, :string
    add_column :users, :current_academic_activities, :string
    add_column :users, :next_academic_activities, :string
  end
end
