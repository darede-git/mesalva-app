class AddFeedbackToEssaySubmission < ActiveRecord::Migration[5.2]
  def change
    add_column :essay_submissions, :feedback, :text
    add_column :essay_submissions, :correction_type, :string, default: 'redacao-padrao'
    rename_column :essay_submissions, :justification, :uncorrectable_message
  end
end
