class RenameAnswerGridToEnemAnswers < ActiveRecord::Migration[4.2]
  def change
    rename_table :answer_grids, :enem_answers

    rename_column :enem_answers, :answer, :value
    rename_column :enem_answers, :correct_answer, :correct_value
    rename_column :enem_answers, :question_id, :quiz_question_id
    rename_column :enem_answers, :alternative_id, :quiz_alternative_id

    add_foreign_key :enem_answers, :quiz_questions
    add_foreign_key :enem_answers, :quiz_alternatives

    add_index :enem_answers, :quiz_question_id
    add_index :enem_answers, :quiz_alternative_id
  end
end
