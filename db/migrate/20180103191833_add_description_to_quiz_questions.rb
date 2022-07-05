class AddDescriptionToQuizQuestions < ActiveRecord::Migration[4.2]
  def change
    add_column :quiz_questions, :description, :text
    add_column :quiz_questions, :position, :int
  end
end
