class AddItemStreamingIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :items, [:starts_at, :ends_at, :item_type]
  end
end
