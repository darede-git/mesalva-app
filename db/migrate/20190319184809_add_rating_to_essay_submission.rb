class AddRatingToEssaySubmission < ActiveRecord::Migration[5.2]
  def change
    add_column :essay_submissions, :rating, :integer, default: 0
  end
end
