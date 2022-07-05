class CreateItemMedia < ActiveRecord::Migration[4.2]
  def change
    create_table :item_media do |t|
      t.belongs_to :item, index: true, foreign_key: true
      t.belongs_to :medium, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
