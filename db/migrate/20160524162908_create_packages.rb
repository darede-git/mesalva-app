class CreatePackages < ActiveRecord::Migration[4.2]
  def change
    create_table :packages do |t|
      t.string :name
      t.string :slug
      t.integer :duration_in_days
      t.datetime :expires_at
      t.boolean :active, default: true
      t.string :iugu_plan_id
      t.string :iugu_plan_identifier

      t.timestamps null: false
    end
    add_index :packages, :slug, unique: true
    add_index :packages, :iugu_plan_id, unique: true
    add_index :packages, :iugu_plan_identifier, unique: true
  end
end
