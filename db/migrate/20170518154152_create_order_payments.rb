class CreateOrderPayments < ActiveRecord::Migration[4.2]
  def change
    create_table :order_payments do |t|
      t.references :order, index: true, foreign_key: true
      t.string :payment_method,   null: false
      t.integer :amount_in_cents, null: false
      t.integer :installments,    null: false
      t.string :card_token
      t.jsonb :metadata

      t.timestamps null: false
    end
  end
end
