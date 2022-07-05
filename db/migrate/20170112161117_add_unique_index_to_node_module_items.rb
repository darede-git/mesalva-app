class AddUniqueIndexToNodeModuleItems < ActiveRecord::Migration[4.2]
  def change
    add_index :node_module_items, [:node_module_id, :item_id], :unique => true
  end
end
