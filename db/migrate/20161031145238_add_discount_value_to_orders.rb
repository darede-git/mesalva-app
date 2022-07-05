class AddDiscountValueToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :discount_value, :decimal, default: 0.0
    add_reference :orders, :discount, index: true, foreign_key: true
  end
end
