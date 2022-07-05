# frozen_string_literal: true

class CreateEssayCorrectionChecks < ActiveRecord::Migration[5.2]
  def change
    create_table :essay_correction_checks do |t|
      t.float :checked, array: true
      t.references :correction_style_criteria_check,
                   foreign_key: true,
                   index: { name: 'essay_correction_checks_on_correction_style_criteria_check_id' }
      t.references :essay_submission, foreign_key: true

      t.timestamps
    end
  end
end
