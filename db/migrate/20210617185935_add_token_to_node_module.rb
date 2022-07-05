# frozen_string_literal: true

class AddTokenToNodeModule < ActiveRecord::Migration[5.2]
  def change
    add_column :node_modules, :token, :string
    add_index :node_modules, :token, unique: true
  end
end
