class AddIndexToTables < ActiveRecord::Migration[4.2]
  def change
    add_index :media, :medium_type
    add_index :permalink_nodes, :position
    add_index :nodes, :node_type
    add_index :node_modules, :slug
    add_index :nodes, [:id, :ancestry]
  end
end
