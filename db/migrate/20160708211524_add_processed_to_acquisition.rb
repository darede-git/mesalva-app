class AddProcessedToAcquisition < ActiveRecord::Migration[4.2]
  def change
    add_column :acquisitions, :processed, :boolean, default: false
  end
end
