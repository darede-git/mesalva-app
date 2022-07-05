class CreateAcquisitionItems < ActiveRecord::Migration[4.2]
  def change
    create_table :acquisition_items do |t|
      t.references :acquisition, index: true, foreign_key: true
      t.integer :item_type
      t.integer :item_id

      t.timestamps null: false
    end
  end
end
