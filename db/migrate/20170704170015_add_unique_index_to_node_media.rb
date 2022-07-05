class AddUniqueIndexToNodeMedia < ActiveRecord::Migration[4.2]
  def change
    add_index :node_media, [:node_id, :medium_id], unique: true
  end
end
