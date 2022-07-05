class CreateImages < ActiveRecord::Migration[4.2]
  def change
    create_table :images do |t|
      t.string :image

      t.timestamps null: false
    end
  end
end
