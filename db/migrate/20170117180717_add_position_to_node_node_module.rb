class AddPositionToNodeNodeModule < ActiveRecord::Migration[4.2]
  def change
    add_column :node_node_modules, :position, :integer
  end
end
