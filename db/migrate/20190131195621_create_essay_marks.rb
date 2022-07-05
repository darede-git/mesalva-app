class CreateEssayMarks < ActiveRecord::Migration[5.2]
  def change
    create_table :essay_marks do |t|
      t.text :description
      t.string :mark_type
      t.hstore :coordinate
      t.references :essay_submission, foreign_key: true

      t.timestamps
    end
  end
end
