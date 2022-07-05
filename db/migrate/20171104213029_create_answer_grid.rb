class CreateAnswerGrid < ActiveRecord::Migration[4.2]
  def change
    create_table :answer_grids do |t|
      t.integer :question_id
      t.string :answer
      t.string :correct_answer
      t.integer :alternative_id
      t.boolean :correct
      t.integer :user_id
      t.string :exam
      t.string :color
    end

    add_index :answer_grids, :user_id
  end
end
