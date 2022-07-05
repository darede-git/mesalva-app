# frozen_string_literal: true

class CreateEssaySubmissionGrades < ActiveRecord::Migration[5.2]
  def change
    create_table :essay_submission_grades do |t|
      t.references :essay_submission, foreign_key: true
      t.references :correction_style_criteria, foreign_key: true
      t.decimal :grade

      t.timestamps
    end
  end
end
