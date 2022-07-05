class RenameOrderColumns < ActiveRecord::Migration[4.2]
  def change
    remove_column :orders, :discount_value
    add_column :orders, :discount_in_cents, :integer, null: false, default: 0
  end
end
