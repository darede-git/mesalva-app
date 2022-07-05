class AddContentTeacherActive < ActiveRecord::Migration[5.2]
  def change
    add_column :content_teachers, :active, :boolean, default: true
  end
end
