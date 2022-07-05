class AddIuguColumnsToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :slug, :string
    add_column :users, :iugu_customer_id, :string
    add_column :users, :iugu_payment_token, :string
    add_column :users, :premium, :boolean, default: false, null: false

    add_index :users, :slug, unique: true
  end
end
