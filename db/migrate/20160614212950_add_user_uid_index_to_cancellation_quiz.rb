class AddUserUidIndexToCancellationQuiz < ActiveRecord::Migration[4.2]
  def change
    add_index :cancellation_quizzes, :user_uid
  end
end
