class AddsBarcodeOnPayments < ActiveRecord::Migration[4.2]
  def change
    add_column :order_payments, :barcode, :string
  end
end
