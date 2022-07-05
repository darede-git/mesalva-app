class CreateAppStoreTransaction < ActiveRecord::Migration[4.2]
  def change
    create_table :app_store_transactions do |t|
      t.string :transaction_id
      t.references :order_payment, index: true, foreign_key: true
      t.json :metadata
    end
  end
end
