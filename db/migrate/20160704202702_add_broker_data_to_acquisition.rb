class AddBrokerDataToAcquisition < ActiveRecord::Migration[4.2]
  def change
    add_column :acquisitions, :broker_data, :hstore
  end
end
