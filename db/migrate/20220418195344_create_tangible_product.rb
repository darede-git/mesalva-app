# frozen_string_literal: true

class CreateTangibleProduct < ActiveRecord::Migration[5.2]
  def change
    create_table :tangible_products do |t|
      t.string :name, nullable: false
      t.float :height, nullable: false
      t.float :length, nullable: false
      t.float :width, nullable: false
      t.float :weight, nullable: false
      t.text :description
      t.string :sku, unique: true, nullable: false
      t.string :image
    end
  end
end
