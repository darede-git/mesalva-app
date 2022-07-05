# frozen_string_literal: true

class CreateShortenedUrlsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :shortened_urls do |t|
      t.integer :owner_id
      t.string :owner_type, limit: 20
      t.text :url, null: false, length: 2083
      t.string :unique_key, limit: 10, null: false
      t.string :category
      t.integer :use_count, null: false, default: 0
      t.datetime :expires_at
      t.references :owner_id, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :shortened_urls, :unique_key, unique: true
    add_index :shortened_urls, :url, length: 2083
    add_index :shortened_urls, %i[owner_id owner_type]
    add_index :shortened_urls, :category
  end
end
