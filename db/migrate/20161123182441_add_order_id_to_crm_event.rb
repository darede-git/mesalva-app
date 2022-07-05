class AddOrderIdToCrmEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :crm_events, :order_id, :integer
  end
end
