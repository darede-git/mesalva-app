class AddAnswerGridToAnswers < ActiveRecord::Migration[4.2]
  def change
    add_reference :enem_answers, :enem_answer_grid, index: true,
                  foreign_key: true
  end
end
