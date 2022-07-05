# frozen_string_literal: true

class CreateCorrectionStyleCriteriaChecks < ActiveRecord::Migration[5.2]
  def change
    create_table :correction_style_criteria_checks do |t|
      t.string :name
      t.references :correction_style_criteria,
                   foreign_key: true,
                   index: { name: 'correction_style_criteria_checks_on_correction_style_criteria' }

      t.timestamps
    end
  end
end
