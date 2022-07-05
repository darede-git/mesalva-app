class AddColumnOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :delivery_status, :string
    add_column :orders, :tracking_code, :string
    add_column :orders, :bling_id, :integer
  end
end
