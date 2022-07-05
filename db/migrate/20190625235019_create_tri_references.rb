class CreateTriReferences < ActiveRecord::Migration[5.2]
  def change
    create_table :tri_references do |t|
      t.references :item, foreign_key: true, unique: true
      t.integer :year
      t.string :exam
      t.string :language

      t.timestamps
    end
  end
end
