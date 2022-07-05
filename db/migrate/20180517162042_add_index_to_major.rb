class AddIndexToMajor < ActiveRecord::Migration[4.2]
  def change
    add_index :majors, :name, unique: true
  end
end
