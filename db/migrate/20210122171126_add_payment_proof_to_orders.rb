class AddPaymentProofToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :payment_proof, :string
  end
end
