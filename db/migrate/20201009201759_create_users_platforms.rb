# frozen_string_literal: true

class CreateUsersPlatforms < ActiveRecord::Migration[5.2]
  def change
    create_table :users_platforms do |t|
      t.references :user, foreign_key: true
      t.references :platform, foreign_key: true
      t.string :role, default: 'student'
      t.boolean :verified, default: false

      t.timestamps
    end
  end
end
