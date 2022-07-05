class AddPositionToNodeModuleItem < ActiveRecord::Migration[4.2]
  def change
    add_column :node_module_items, :position, :integer
  end
end
