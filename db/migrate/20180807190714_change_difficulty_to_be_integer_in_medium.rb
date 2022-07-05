class ChangeDifficultyToBeIntegerInMedium < ActiveRecord::Migration[4.2]
  def change
    change_column :media, :difficulty, 'integer USING CAST(difficulty AS integer)'
  end
end
