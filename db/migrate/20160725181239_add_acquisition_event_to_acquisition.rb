class AddAcquisitionEventToAcquisition < ActiveRecord::Migration[4.2]
  def change
    add_column :acquisitions, :acquisition_event, :integer, default:1
  end
end
