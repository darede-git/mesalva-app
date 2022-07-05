class AddGradeToEssaySubmission < ActiveRecord::Migration[4.2]
  def change
    change_table :essay_submissions do |t|
      t.hstore :grade
      t.string :justification
      t.string :updated_by_uid
      t.string :token
    end
    change_column :essay_submissions, :status,  'integer USING CAST(status AS integer)'
  end
end
