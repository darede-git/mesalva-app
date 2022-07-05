class CreateLpPages < ActiveRecord::Migration[5.2]
  def change
    create_table :lp_pages do |t|
      t.string :name, null: false
      t.string :slug, null: false, unique: true
      t.jsonb :schema, default: {}
      t.jsonb :data, default: {}
      t.timestamps
    end
  end
end
