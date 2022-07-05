class CreateSisuWeighting < ActiveRecord::Migration[4.2]
  def change
    create_table :sisu_weightings do |t|
      t.string :institute
      t.string :college
      t.string :course
      t.string :shift
      t.integer :cnat_weight
      t.integer :chum_weight
      t.integer :ling_weight
      t.integer :mat_weight
      t.integer :red_weight

      t.timestamps null: false
    end
    add_index :sisu_weightings, :institute
    add_index :sisu_weightings, :course
  end
end
