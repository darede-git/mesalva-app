class CreateSisuSatisfactions < ActiveRecord::Migration[5.2]
  def change
    create_table :sisu_satisfactions do |t|
      t.boolean :satisfaction, default: false
      t.string :plan
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
