class AddsErrorMessageToPayments < ActiveRecord::Migration[4.2]
  def change
    add_column :order_payments, :error_message, :string
    add_column :order_payments, :error_code, :string
  end
end
