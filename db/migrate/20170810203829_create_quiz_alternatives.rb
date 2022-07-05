class CreateQuizAlternatives < ActiveRecord::Migration[4.2]
  def change
    create_table :quiz_alternatives do |t|
      t.belongs_to :quiz_question, index: true, foreign_key: true
      t.string :description
      t.string :value

      t.timestamps null: false
    end
  end
end
