class AddsPagarmeTransactionsToPaymentAndSubscription < ActiveRecord::Migration[4.2]
  def change
    create_table :pagarme_transactions do |t|
      t.string :pagarme_id
      t.references :order_payment, index: true, foreign_key: true
      t.jsonb :metadata


    end

    create_table :pagarme_subscriptions do |t|
      t.string :pagarme_id
      t.references :subscription, index: true, foreign_key: true
      t.jsonb :metadata
    end
  end
end
