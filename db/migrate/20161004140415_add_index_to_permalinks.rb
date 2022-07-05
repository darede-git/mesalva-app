class AddIndexToPermalinks < ActiveRecord::Migration[4.2]
  def change
    add_index :permalinks, :slug
  end
end
