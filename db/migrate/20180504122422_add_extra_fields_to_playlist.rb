class AddExtraFieldsToPlaylist < ActiveRecord::Migration[4.2]
  def change
    add_column :playlists, :token, :string
    add_column :playlists, :visibility, :string
    add_column :playlists, :image, :string
    add_column :playlists, :college, :string
    add_column :playlists, :major, :string
    add_column :playlists, :course, :string
    add_column :playlists, :teacher, :string
    add_column :playlists, :items_count, :integer
  end
end
