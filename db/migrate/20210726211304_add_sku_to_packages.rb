# frozen_string_literal: true

class AddSkuToPackages < ActiveRecord::Migration[5.2]
  def change
    add_column :packages, :sku, :string
  end
end
