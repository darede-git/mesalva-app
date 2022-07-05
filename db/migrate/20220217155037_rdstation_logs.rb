class RdstationLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :rdstation_logs do |t|
      t.string :trigger
      t.json :leads

      t.timestamps
    end
  end
end
