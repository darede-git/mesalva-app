class AddTokenToSubscription < ActiveRecord::Migration[4.2]
  def change
    add_column :subscriptions, :token, :string
    add_index :subscriptions, :token, unique: true
  end
end
