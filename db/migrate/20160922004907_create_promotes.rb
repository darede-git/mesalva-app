class CreatePromotes < ActiveRecord::Migration[4.2]
  def change
    create_table :promotes do |t|
      t.references :promotable, polymorphic: true, index: true
      t.references :promoter, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
