class ChangeSubmissionOnAnswerGrid < ActiveRecord::Migration[4.2]
  def change
    remove_column :answer_grids, :submission_id

    add_reference :answer_grids, :quiz_form_submission, index: true,
                  foreign_key: true
  end
end
