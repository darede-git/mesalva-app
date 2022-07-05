class AddQuizFormSubmissionToEnemAnswerGrid < ActiveRecord::Migration[4.2]
  def change
    add_reference :enem_answer_grids, :quiz_form_submission, index: true,
                  foreign_key: true
    add_column :enem_answer_grids, :year, :integer, default: 2017
  end
end
