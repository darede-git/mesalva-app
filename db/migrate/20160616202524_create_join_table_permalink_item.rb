class CreateJoinTablePermalinkItem < ActiveRecord::Migration[4.2]
  def change
    create_join_table :permalinks, :items do |t|
      t.index [:permalink_id, :item_id]
      t.index [:item_id, :permalink_id]
    end
  end
end
