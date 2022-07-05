class MoveFieldsFromUsersToAcademicInfos < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :agenda, :string
    remove_column :users, :current_school, :string
    remove_column :users, :current_school_courses, :string
    remove_column :users, :desired_courses, :string
    remove_column :users, :school_appliances, :string
    remove_column :users, :school_appliance_this_year, :string
    remove_column :users, :favorite_school_subjects, :string
    remove_column :users, :difficult_learning_subjects, :string
    remove_column :users, :current_academic_activities, :string
    remove_column :users, :next_academic_activities, :string

    create_table :academic_infos do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :agenda
      t.string :current_school
      t.string :current_school_courses
      t.string :desired_courses
      t.string :school_appliances
      t.string :school_appliance_this_year
      t.string :favorite_school_subjects
      t.string :difficult_learning_subjects
      t.string :current_academic_activities
      t.string :next_academic_activities
    end
  end
end
