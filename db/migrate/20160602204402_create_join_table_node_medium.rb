class CreateJoinTableNodeMedium < ActiveRecord::Migration[4.2]
  def change
    create_join_table :nodes, :media do |_t|
      # t.index [:node_id, :medium_id]
      # t.index [:medium_id, :node_id]
    end
  end
end
