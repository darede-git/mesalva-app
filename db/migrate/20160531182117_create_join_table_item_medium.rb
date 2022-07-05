class CreateJoinTableItemMedium < ActiveRecord::Migration[4.2]
  def change
    create_join_table :items, :media do |t|
      t.index [:item_id, :medium_id]
      t.index [:medium_id, :item_id]
    end
  end
end
