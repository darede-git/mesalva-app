class CreateItems < ActiveRecord::Migration[4.2]
  def change
    create_table :items do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.string :item_type
      t.boolean :free
      t.boolean :active
      t.string :code

      t.timestamps null: false
    end
  end
end
