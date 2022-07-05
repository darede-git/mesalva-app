class CreatePlaylistPermalinks < ActiveRecord::Migration[4.2]
  def change
    create_table :playlist_permalinks do |t|
      t.belongs_to :playlist, index: true, foreign_key: true
      t.belongs_to :permalink, index: true, foreign_key: true
      t.integer :position, index: true

      t.timestamps null: false
    end
  end
end
