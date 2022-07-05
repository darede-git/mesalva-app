class CreateQuizQuestions < ActiveRecord::Migration[4.2]
  def change
    create_table :quiz_questions do |t|
      t.belongs_to :quiz_form, index: true, foreign_key: true
      t.string :statement

      t.timestamps null: false
    end
  end
end
