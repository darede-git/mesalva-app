class AddUpdatedAtCreatedAtToTransactionTables < ActiveRecord::Migration[5.2]
  def change
    add_column :app_store_transactions, :updated_at, :timestamp
    add_column :app_store_transactions, :created_at, :timestamp

    add_column :play_store_transactions, :updated_at, :timestamp
    add_column :play_store_transactions, :created_at, :timestamp

    add_column :pagarme_subscriptions, :updated_at, :timestamp
    add_column :pagarme_subscriptions, :created_at, :timestamp

    add_column :pagarme_transactions, :updated_at, :timestamp
    add_column :pagarme_transactions, :created_at, :timestamp
  end
end
