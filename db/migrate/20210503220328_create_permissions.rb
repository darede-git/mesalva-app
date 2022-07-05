# frozen_string_literal: true

class CreatePermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :permissions do |t|
      t.string :controller_name, nullable: false
      t.string :action, nullable: false

      t.timestamps
    end

    add_index :permissions, [:controller_name, :action], unique: true

  end
end
