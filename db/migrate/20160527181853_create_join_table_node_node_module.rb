class CreateJoinTableNodeNodeModule < ActiveRecord::Migration[4.2]
  def change
    create_join_table :nodes, :node_modules do |t|
      t.index [:node_id, :node_module_id]
      t.index [:node_module_id, :node_id]
    end
  end
end
