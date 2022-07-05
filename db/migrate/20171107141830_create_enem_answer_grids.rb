class CreateEnemAnswerGrids < ActiveRecord::Migration[4.2]
  def change
    create_table :enem_answer_grids do |t|
      t.string :exam
      t.string :language
      t.string :color
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
