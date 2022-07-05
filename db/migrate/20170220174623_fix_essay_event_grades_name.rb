class FixEssayEventGradesName < ActiveRecord::Migration[4.2]
  def change
    rename_column :essay_submissions, :grade, :grades
  end
end
