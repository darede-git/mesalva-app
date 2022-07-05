class CreateAddresses < ActiveRecord::Migration[4.2]
  def change
    create_table :addresses do |t|
      t.string :street
      t.integer :street_number
      t.string :street_detail
      t.string :neighborhood
      t.string :city
      t.string :zip_code
      t.string :state
      t.string :country
      t.string :area_code
      t.string :phone_number
      t.references :addressable, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end
