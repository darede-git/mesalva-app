class AddPositionToEducationLevel < ActiveRecord::Migration[4.2]
  def change
    add_column :education_levels, :position, :integer
    add_index :education_levels, :position
  end
end
