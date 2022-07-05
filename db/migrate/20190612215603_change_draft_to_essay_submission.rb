class ChangeDraftToEssaySubmission < ActiveRecord::Migration[5.2]
  def change
    change_column :essay_submissions, :draft, :jsonb, null: false, default: {}
  end
end
