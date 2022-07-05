class DropAcquisitionItems < ActiveRecord::Migration[4.2]
  def change
    drop_table :acquisition_items
  end
end
