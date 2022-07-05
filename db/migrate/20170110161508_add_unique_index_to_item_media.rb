class AddUniqueIndexToItemMedia < ActiveRecord::Migration[4.2]
  def change
    add_index :item_media, [:item_id, :medium_id], :unique => true
  end
end
