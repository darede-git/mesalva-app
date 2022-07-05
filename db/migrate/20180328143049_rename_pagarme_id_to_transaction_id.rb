class RenamePagarmeIdToTransactionId < ActiveRecord::Migration[4.2]
  def change
  	rename_column :pagarme_transactions, :pagarme_id, :transaction_id
  end
end
