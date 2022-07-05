class RemoveColumnsToEnemAnswers < ActiveRecord::Migration[4.2]
  def change
    remove_column :enem_answers, :user_id
    remove_column :enem_answers, :exam
    remove_column :enem_answers, :color
  end
end
