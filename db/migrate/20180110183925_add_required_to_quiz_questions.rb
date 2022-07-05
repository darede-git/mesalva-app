class AddRequiredToQuizQuestions < ActiveRecord::Migration[4.2]
  def change
    add_column :quiz_questions, :required, :boolean, default: false
  end
end
