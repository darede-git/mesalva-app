class AddIndexToPlaylistPermalinks < ActiveRecord::Migration[4.2]
  def change
    remove_index :permalinks_playlists, [:playlist_id, :permalink_id]
    add_index :permalinks_playlists, [:playlist_id, :permalink_id], unique: true
  end
end
