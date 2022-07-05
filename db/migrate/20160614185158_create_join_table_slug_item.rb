class CreateJoinTableSlugItem < ActiveRecord::Migration[4.2]
  def change
    create_join_table :slugs, :items do |t|
      t.index [:slug_id, :item_id]
      t.index [:item_id, :slug_id]
    end
  end
end
