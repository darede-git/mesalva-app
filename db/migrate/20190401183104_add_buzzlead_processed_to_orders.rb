class AddBuzzleadProcessedToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :buzzlead_processed, :boolean, default: false
  end
end
