class DropTableItemsPermalinks < ActiveRecord::Migration[4.2]
  def change
    drop_table :items_permalinks
  end
end
