class CreateJoinTablePermalinkNode < ActiveRecord::Migration[4.2]
  def change
    create_join_table :permalinks, :nodes do |t|
      t.index [:permalink_id, :node_id]
      t.index [:node_id, :permalink_id]
    end
  end
end
