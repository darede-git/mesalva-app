class AddInstallmentsToAcquisition < ActiveRecord::Migration[4.2]
  def change
    add_column :acquisitions, :installments, :integer, default: 1
  end
end
