class AddBrokerInvoiceToAcquisition < ActiveRecord::Migration[4.2]
  def change
    add_column :acquisitions, :broker_invoice, :string
  end
end
