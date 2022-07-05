class AddQuestionTypeToQuizQuestion < ActiveRecord::Migration[4.2]
  def change
    add_column :quiz_questions, :question_type, :string
  end
end
