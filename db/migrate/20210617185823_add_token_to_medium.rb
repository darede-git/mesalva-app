# frozen_string_literal: true

class AddTokenToMedium < ActiveRecord::Migration[5.2]
  def change
    add_column :media, :token, :string
    add_index :media, :token, unique: true
  end
end
