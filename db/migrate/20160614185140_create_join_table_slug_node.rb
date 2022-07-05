class CreateJoinTableSlugNode < ActiveRecord::Migration[4.2]
  def change
    create_join_table :slugs, :nodes do |t|
      t.index [:slug_id, :node_id]
      t.index [:node_id, :slug_id]
    end
  end
end
