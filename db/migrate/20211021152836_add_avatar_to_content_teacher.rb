class AddAvatarToContentTeacher < ActiveRecord::Migration[5.2]
  def change
    add_column :content_teachers, :avatar, :string
  end
end
