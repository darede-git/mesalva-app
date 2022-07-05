class AddNameToDiscounts < ActiveRecord::Migration[4.2]
  def change
    add_column :discounts, :name, :string
  end
end
