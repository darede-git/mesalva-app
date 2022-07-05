class AddColumnPackage < ActiveRecord::Migration[5.2]
  def change
    add_reference :packages, :tangible_product
    add_column :packages, :tangible_product_discount_percent, :float
  end
end
