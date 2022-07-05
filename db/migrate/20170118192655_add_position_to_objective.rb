class AddPositionToObjective < ActiveRecord::Migration[4.2]
  def change
    add_column :objectives, :position, :integer
  end
end
