class CreateDiscounts < ActiveRecord::Migration[4.2]
  def change
    create_table :discounts do |t|
      t.belongs_to :package, index: true, foreign_key: true
      t.datetime :starts_at
      t.datetime :expires_at
      t.integer :percentual_discount
      t.string :rule
      t.text :package_ids, array: true

      t.timestamps null: false
    end
  end
end
