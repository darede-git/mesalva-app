# frozen_string_literal: true

class AddTokenToNode < ActiveRecord::Migration[5.2]
  def change
    add_column :nodes, :token, :string
    add_index :nodes, :token, unique: true
  end
end
