class CreateForums < ActiveRecord::Migration[4.2]
  def change
    create_table :forums do |t|
      t.text :description
      t.references :node, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
