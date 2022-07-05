class CreatePlatforms < ActiveRecord::Migration[5.2]
  def change
    create_table :platforms do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.jsonb :theme, null: false, default: {}
      t.boolean :public, null: false, default: false

      t.timestamps
    end
  end
end
