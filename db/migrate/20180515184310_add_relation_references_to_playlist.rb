class AddRelationReferencesToPlaylist < ActiveRecord::Migration[4.2]
  def change
    remove_column :playlists, :college
    remove_column :playlists, :major

    create_table :colleges do |t|
      t.string :name
    end

    create_table :majors do |t|
      t.string :name
    end

    add_reference :playlists, :college, foreign_key: true
    add_reference :playlists, :major, foreign_key: true
  end
end
