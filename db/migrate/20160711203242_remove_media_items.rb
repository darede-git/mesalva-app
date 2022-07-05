class RemoveMediaItems < ActiveRecord::Migration[4.2]
  def change
    drop_table :items_media
  end
end
