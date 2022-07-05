class CreateScholarRecords < ActiveRecord::Migration[4.2]
  def change
    create_table :scholar_records do |t|
      t.string :education_level
      t.references :user, index: true, foreign_key: true
      t.boolean :level_concluded, null: false, default: false
      t.references :major, index: true, foreign_key: true
      t.references :school, index: true, foreign_key: true
      t.references :college, index: true, foreign_key: true
      t.integer :study_phase
      t.boolean :active, null: false, default: true

      t.timestamps null: false
    end
  end
end
