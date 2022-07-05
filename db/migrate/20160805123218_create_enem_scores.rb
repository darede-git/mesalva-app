class CreateEnemScores < ActiveRecord::Migration[4.2]
  def change
    create_table :enem_scores do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :title
      t.string :questions
      t.decimal :score

      t.timestamps null: false
    end
  end
end
