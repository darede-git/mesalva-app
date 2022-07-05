class CreatePlaylists < ActiveRecord::Migration[4.2]
  def change
    create_table :playlists do |t|
      t.string :name
      t.string :description
      t.boolean :free
      t.integer :seconds_duration
      t.references :user, index: true

      t.timestamps null: false
    end

    create_join_table :playlists, :permalinks do |t|
      t.index [:playlist_id, :permalink_id]
      t.index [:permalink_id, :playlist_id]
    end
  end
end
