class RemoveActiveToAcquisitions < ActiveRecord::Migration[4.2]
  def change
    remove_column :acquisitions, :active
  end
end
