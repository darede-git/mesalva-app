class AddCanonicalUriToPermalinks < ActiveRecord::Migration[4.2]
  def change
    add_column :permalinks, :canonical_uri, :string
    add_index :permalinks, :canonical_uri
  end
end
