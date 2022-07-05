class CreateMedia < ActiveRecord::Migration[4.2]
  def change
    create_table :media do |t|
      t.string :name
      t.text :description
      t.string :url
      t.string :medium_type
      t.binary :file_data
      t.string :attachment
      t.decimal :length
      t.text :medium_text
      t.integer :video_id
      t.string :provider

      t.timestamps null: false
    end
  end
end
