class CreatePrepTestScores < ActiveRecord::Migration[4.2]
  def change
    create_table :prep_test_scores do |t|
      t.float :score
      t.string :permalink_slug
      t.string :submission_token
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :prep_test_scores, :submission_token
  end
end
