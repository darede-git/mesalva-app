class CreateInstructorUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :instructor_users do |t|
      t.references :user, foreign_key: true
      t.references :instructor, foreign_key: true
    end
  end
end
