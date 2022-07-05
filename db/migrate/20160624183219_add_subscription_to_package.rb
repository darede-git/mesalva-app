class AddSubscriptionToPackage < ActiveRecord::Migration[4.2]
  def change
    add_column :packages, :subscription, :boolean, default: false
  end
end
