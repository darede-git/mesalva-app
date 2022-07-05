# frozen_string_literal: true

class CreateSystemSetting < ActiveRecord::Migration[5.2]
  def change
    create_table :system_settings do |t|
      t.string :key, null: false
      t.json :value

      t.timestamps
    end

    add_index :system_settings, :key, unique: true
  end
end
