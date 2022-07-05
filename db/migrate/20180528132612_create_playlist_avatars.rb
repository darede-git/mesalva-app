class CreatePlaylistAvatars < ActiveRecord::Migration[4.2]
  def change
    create_table :playlist_avatars do |t|
      t.string :image
      t.boolean :active, default: true

      t.timestamps null: false
    end
  end
end
