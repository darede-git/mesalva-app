class AddColumnEmailToContentTeacher < ActiveRecord::Migration[5.2]
  def change
    add_column :content_teachers, :email, :string
  end
end
