class RemoveEnemScores < ActiveRecord::Migration[5.2]
  def change
    drop_table :enem_scores
  end
end
