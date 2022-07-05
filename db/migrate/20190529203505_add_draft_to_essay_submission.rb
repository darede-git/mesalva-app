class AddDraftToEssaySubmission < ActiveRecord::Migration[5.2]
  def change
    add_column :essay_submissions, :draft, :jsonb, null: false, default: '{}'
  end
end
