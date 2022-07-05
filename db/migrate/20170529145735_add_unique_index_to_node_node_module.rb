class AddUniqueIndexToNodeNodeModule < ActiveRecord::Migration[4.2]
  def change
    add_index :node_node_modules, [:node_module_id, :node_id], unique: true
  end
end
