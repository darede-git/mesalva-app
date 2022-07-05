# frozen_string_literal: true

class CreatePlatformSchools < ActiveRecord::Migration[5.2]
  def change
    create_table :platform_schools do |t|
      t.string :name, null: false
      t.string :city, null: false
      t.references :platform, foreign_key: true, null: false

      t.timestamps
    end
  end
end
