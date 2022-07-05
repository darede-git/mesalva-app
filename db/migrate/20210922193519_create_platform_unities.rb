# frozen_string_literal: true

class CreatePlatformUnities < ActiveRecord::Migration[5.2]
  def change
    create_table :platform_unities do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :uf
      t.string :city
      t.references :platform, foreign_key: true
      t.references :user_platforms, foreign_key: true

      t.timestamps
    end
  end
end
