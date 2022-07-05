class CreateAccesses < ActiveRecord::Migration[4.2]
  def change
    create_table :accesses do |t|
      t.references :user, index: true, foreign_key: true
      t.references :acquisition, index: true, foreign_key: true
      t.references :package, index: true, foreign_key: true
      t.datetime :starts_at
      t.datetime :expires_at
      t.boolean :active, default: true, null: false

      t.timestamps null: false
    end
  end
end
