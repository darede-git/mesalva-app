class AddIndexToPermalinkEvents < ActiveRecord::Migration[4.2]
  def change
    add_index :permalink_events, :permalink_node_id
    add_index :permalink_events, :permalink_node_module_id
    add_index :permalink_events, :permalink_item_id
    add_index :permalink_events, :permalink_medium_id
    add_index :permalink_events, :event_name
    add_index :permalink_events, :user_id
  end
end
