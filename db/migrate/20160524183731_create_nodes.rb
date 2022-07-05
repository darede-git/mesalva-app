class CreateNodes < ActiveRecord::Migration[4.2]
  def change
    create_table :nodes do |t|
      t.string :name
      t.boolean :active
      t.integer :weight
      t.string :slug
      t.string :code
      t.text :description
      t.string :thumb
      t.string :objective
      t.string :suggested_to
      t.string :pre_requisite
      t.string :image
      t.string :node_type
      t.string :color_name
      t.boolean :free
      t.string :url
      t.binary :file_data
      t.string :attachment
      t.decimal :length
      t.integer :created_by
      t.integer :updated_by
      t.text :node_text
      t.integer :video_id
      t.string :provider
      t.text :correction
      t.string :matter
      t.string :subject
      t.string :difficulty
      t.string :university
      t.string :concourse

      t.timestamps null: false
    end
  end
end
