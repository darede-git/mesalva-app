class CreatePermalinkMedia < ActiveRecord::Migration[4.2]
  def change
    create_table :permalink_media do |t|
      t.belongs_to :permalink, index: true, foreign_key: true
      t.belongs_to :medium, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
