class AddPlaylistAvatarRefToPlaylists < ActiveRecord::Migration[4.2]
  def change
    add_reference :playlists, :playlist_avatar, index: true, foreign_key: true
  end
end
