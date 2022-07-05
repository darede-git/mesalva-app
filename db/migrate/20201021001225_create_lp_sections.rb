class CreateLpSections < ActiveRecord::Migration[5.2]
  def change
    create_table :lp_sections do |t|
      t.string :name, null: false, unique: true
      t.jsonb :schema, null: false, default: {}
      t.timestamps
    end
  end
end
