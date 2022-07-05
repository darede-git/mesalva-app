class RenameTableAcquisitionToOrder < ActiveRecord::Migration[4.2]
  def change
    rename_table :acquisitions, :orders
  end
end
