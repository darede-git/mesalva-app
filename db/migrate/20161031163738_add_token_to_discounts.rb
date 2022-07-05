class AddTokenToDiscounts < ActiveRecord::Migration[4.2]
  def change
    add_column :discounts, :token, :string
    add_index :discounts, :token, unique: true
  end
end
