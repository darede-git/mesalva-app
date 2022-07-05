class RenameColumnsInPermalinkEvents < ActiveRecord::Migration[4.2]
  def change
    rename_column :permalink_events, :permalink_node_ids, :permalink_node_id
    rename_column :permalink_events, :permalink_nodes, :permalink_node
    rename_column :permalink_events, :permalink_node_slugs, :permalink_node_slug
    rename_column :permalink_events, :permalink_node_types, :permalink_node_type
  end
end
