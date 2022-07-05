class CreateMarathonRankings < ActiveRecord::Migration[5.2]
  def change
    create_table :marathon_rankings do |t|
      t.integer :correct_answers_day
      t.integer :correct_answers_total
      t.integer :answers_day
      t.integer :answers_total
      t.integer :ranking_day
      t.integer :ranking_total
      t.integer :user_id

      t.timestamps
    end
  end
end
