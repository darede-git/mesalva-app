class AddSubmissionAtToPermalinkEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :permalink_events, :submission_at, :datetime
    add_column :permalink_events, :submission_token, :string
  end
end
