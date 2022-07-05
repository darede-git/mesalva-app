class RemoveUnusedIndexesFromPermalinkEvents < ActiveRecord::Migration[4.2]
  def change
    remove_index :permalink_events, :event_name
    remove_index :permalink_events, :permalink_item_id
    remove_index :permalink_events, :permalink_medium_id
    remove_index :permalink_events, :permalink_node_id
    remove_index :permalink_events, :permalink_node_module_id
    remove_index :permalink_events, :permalink_slug
    remove_index :permalink_events, :user_id
  end
end
