class CreateCancellationQuizzes < ActiveRecord::Migration[4.2]
  def change
    create_table :cancellation_quizzes do |t|
      t.string :user_uid
      t.integer :acquisition_id
      t.hstore :quiz

      t.timestamps null: false
    end
  end
end
