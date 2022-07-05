class AlterColumnsToPrices < ActiveRecord::Migration[4.2]
  def change
    remove_column :prices, :starts_at
    remove_column :prices, :expires_at
    add_column :prices, :price_type, :string
  end
end
