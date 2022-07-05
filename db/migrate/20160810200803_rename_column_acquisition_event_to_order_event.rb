class RenameColumnAcquisitionEventToOrderEvent < ActiveRecord::Migration[4.2]
  def change
    rename_column :orders, :acquisition_event, :order_event
  end
end
