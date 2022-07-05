class CreateVouchers < ActiveRecord::Migration[4.2]
  def change
    create_table :vouchers do |t|
      t.belongs_to :discount, index: true, foreign_key: true
      t.string :token
      t.boolean :active, default: true

      t.timestamps null: false
    end
  end
end
