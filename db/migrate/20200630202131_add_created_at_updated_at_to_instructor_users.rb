class AddCreatedAtUpdatedAtToInstructorUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :instructor_users, :created_at, :timestamp
    add_column :instructor_users, :updated_at, :timestamp
  end
end
