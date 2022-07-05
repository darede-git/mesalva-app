class AddSubscriptionToOrders < ActiveRecord::Migration[4.2]
  def change
    add_reference :orders, :subscription, index: true, foreign_key: true
  end
end
