class CreateContentTeachers < ActiveRecord::Migration[5.2]
  def change
    create_table :content_teachers do |t|
      t.string :name
      t.string :slug
      t.string :image
      t.string :description
      t.string :content_type

      t.timestamps
    end
  end
end
