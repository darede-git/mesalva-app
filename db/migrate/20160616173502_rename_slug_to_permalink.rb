class RenameSlugToPermalink < ActiveRecord::Migration[4.2]
  def change
    rename_table :slugs, :permalinks
  end
end
