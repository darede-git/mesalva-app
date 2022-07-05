class AddPositionToItemMedia < ActiveRecord::Migration[4.2]
  def change
    add_column :item_media, :position, :integer
  end
end
