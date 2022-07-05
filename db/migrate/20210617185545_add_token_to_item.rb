# frozen_string_literal: true

class AddTokenToItem < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :token, :string
    add_index :items, :token, unique: true
  end
end
