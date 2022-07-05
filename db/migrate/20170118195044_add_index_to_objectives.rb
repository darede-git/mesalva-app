class AddIndexToObjectives < ActiveRecord::Migration[4.2]
  def change
    add_index :objectives, :position
  end
end
