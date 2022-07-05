class AddDescriptionToTeachers < ActiveRecord::Migration[4.2]
  def change
    add_column :teachers, :description, :text
  end
end
