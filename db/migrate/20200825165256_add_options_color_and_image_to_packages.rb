# frozen_string_literal: true

class AddOptionsColorAndImageToPackages < ActiveRecord::Migration[5.2]
  def change
    add_column :packages, :options, :jsonb, default: {}, null: false
    add_column :packages, :color_hex, :string
    add_column :packages, :image, :string
  end
end
