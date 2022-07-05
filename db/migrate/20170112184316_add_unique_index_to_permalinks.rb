class AddUniqueIndexToPermalinks < ActiveRecord::Migration[4.2]
  def change
    remove_index :permalinks, :slug
    add_index :permalinks, :slug, :unique => true
  end
end
