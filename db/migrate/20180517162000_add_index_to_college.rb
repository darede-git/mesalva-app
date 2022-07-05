class AddIndexToCollege < ActiveRecord::Migration[4.2]
  def change
    add_index :colleges, :name, unique: true
  end
end
