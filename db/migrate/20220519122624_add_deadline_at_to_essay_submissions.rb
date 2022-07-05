class AddDeadlineAtToEssaySubmissions < ActiveRecord::Migration[5.2]
  def change
    add_column :essay_submissions, :deadline_at, :timestamp

    EssaySubmission.connection.execute("UPDATE essay_submissions
SET deadline_at = (send_date + interval '10' day)
WHERE send_date IS NOT NULL")
  end
end
