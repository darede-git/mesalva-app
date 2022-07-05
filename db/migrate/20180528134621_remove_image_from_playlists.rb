class RemoveImageFromPlaylists < ActiveRecord::Migration[4.2]
  def change
    remove_column :playlists, :image, :string
  end
end
