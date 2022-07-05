# frozen_string_literal: true

class CreateUserSetting < ActiveRecord::Migration[5.2]
  def change
    create_table :user_settings do |t|
      t.references :user, foreign_key: true
      t.string :key
      t.json :value
    end
    add_index :user_settings, [:key, :user_id], unique: true
  end
end
