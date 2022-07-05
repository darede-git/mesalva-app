class AddPositionColumnToNodes < ActiveRecord::Migration[4.2]
  def change
    add_column :nodes, :position, :integer
  end
end
