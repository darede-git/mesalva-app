class AddsInvoiceIdToOrderPayments < ActiveRecord::Migration[4.2]
  def change
    add_column :order_payments, :invoice_id, :integer
    add_column :order_payments, :pdf, :string
  end
end
