class AddUserIdToCancellationQuizzes < ActiveRecord::Migration[4.2]
  def change
    remove_column :cancellation_quizzes, :user_uid, :string
    add_column :cancellation_quizzes, :user_id, :integer
  end
end
