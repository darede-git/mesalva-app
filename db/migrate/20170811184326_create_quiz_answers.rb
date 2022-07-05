class CreateQuizAnswers < ActiveRecord::Migration[4.2]
  def change
    create_table :quiz_answers do |t|
      t.belongs_to :quiz_question, index: true, foreign_key: true
      t.belongs_to :quiz_alternative, index: true, foreign_key: true
      t.belongs_to :quiz_form_submission, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
