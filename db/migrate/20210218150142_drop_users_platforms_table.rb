# frozen_string_literal: true

class DropUsersPlatformsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :users_platforms
    add_column :user_platforms, :options, :jsonb, default: {}, null: false
  end
end
