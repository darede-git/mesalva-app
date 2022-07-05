class AddDraftFeedbackToEssaySubmission < ActiveRecord::Migration[5.2]
  def change
    add_column :essay_submissions, :draft_feedback, :text
  end
end
