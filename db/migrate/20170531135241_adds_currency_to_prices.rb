class AddsCurrencyToPrices < ActiveRecord::Migration[4.2]
  def change
    add_column :prices, :currency, :string, default: 'BRL', null: false
  end
end
