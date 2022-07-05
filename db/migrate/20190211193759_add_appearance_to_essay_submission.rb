class AddAppearanceToEssaySubmission < ActiveRecord::Migration[5.2]
  def change
    add_column :essay_submissions, :appearance, :hstore
  end
end
