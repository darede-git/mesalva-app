class CreateObjectives < ActiveRecord::Migration[4.2]
  def change
    create_table :objectives do |t|
      t.string :product
      t.string :name

      t.timestamps null: false
    end
    add_index :objectives, :name, unique: true
  end
end
