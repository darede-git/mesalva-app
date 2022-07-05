class CreateJoinTablePermalinkNodeModule < ActiveRecord::Migration[4.2]
  def change
    create_join_table :permalinks, :node_modules do |t|
      t.index [:permalink_id, :node_module_id], name: 'permalink_node_module_index'
      t.index [:node_module_id, :permalink_id], name: 'node_module_permalink_index'
    end
  end
end
