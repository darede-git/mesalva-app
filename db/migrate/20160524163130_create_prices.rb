class CreatePrices < ActiveRecord::Migration[4.2]
  def change
    create_table :prices do |t|
      t.decimal :value
      t.datetime :starts_at
      t.datetime :expires_at
      t.boolean :active, default: true
      t.references :package, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
