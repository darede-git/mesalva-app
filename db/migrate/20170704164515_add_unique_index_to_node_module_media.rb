class AddUniqueIndexToNodeModuleMedia < ActiveRecord::Migration[4.2]
  def change
    add_index :node_module_media, [:node_module_id, :medium_id], unique: true
  end
end
