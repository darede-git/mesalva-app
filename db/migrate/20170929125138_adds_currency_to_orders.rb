class AddsCurrencyToOrders < ActiveRecord::Migration[4.2]
  def change
  	add_column :orders, :currency, :string
  end
end
