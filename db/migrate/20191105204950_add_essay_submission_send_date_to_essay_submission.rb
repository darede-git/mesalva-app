class AddEssaySubmissionSendDateToEssaySubmission < ActiveRecord::Migration[5.2]
  def change
    add_column :essay_submissions, :send_date, :timestamp
  end
end
