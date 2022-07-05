class AddTokenToOrder < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :token, :string
    add_index :orders, :token, unique: true
  end
end
