class AddAcquisitionIdIndexToCancellationQuiz < ActiveRecord::Migration[4.2]
  def change
    add_index :cancellation_quizzes, :acquisition_id, :unique => true
  end
end
