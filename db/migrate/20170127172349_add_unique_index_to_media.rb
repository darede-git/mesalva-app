class AddUniqueIndexToMedia < ActiveRecord::Migration[4.2]
  def change
    add_index :media, :slug, unique: true
  end
end
