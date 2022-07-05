class CreateSlugs < ActiveRecord::Migration[4.2]
  def change
    create_table :slugs do |t|
      t.string :slug

      t.timestamps null: false
    end
  end
end
