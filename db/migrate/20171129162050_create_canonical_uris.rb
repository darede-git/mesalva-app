class CreateCanonicalUris < ActiveRecord::Migration[4.2]
  def change
    create_table :canonical_uris do |t|
      t.string :slug

      t.timestamps null: false
    end
    add_index :canonical_uris, :slug
  end
end
