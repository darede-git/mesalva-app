class CreateAcquisitions < ActiveRecord::Migration[4.2]
  def change
    create_table :acquisitions do |t|
      t.references :package, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.decimal :price_paid
      t.datetime :expires_at
      t.boolean :active
      t.integer :status
      t.string :broker
      t.string :checkout_method
      t.integer :purchase_type

      t.timestamps null: false
    end
  end
end
