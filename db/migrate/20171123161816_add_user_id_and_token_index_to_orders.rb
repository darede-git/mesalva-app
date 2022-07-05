class AddUserIdAndTokenIndexToOrders < ActiveRecord::Migration[4.2]
  def change
  	add_index :orders, [:user_id, :token]
  end
end
