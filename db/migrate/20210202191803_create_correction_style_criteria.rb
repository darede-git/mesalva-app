# frozen_string_literal: true

class CreateCorrectionStyleCriteria < ActiveRecord::Migration[5.2]
  def change
    create_table :correction_style_criteria do |t|
      t.string :name
      t.float :values, array: :true, default: []
      t.references :correction_style, foreign_key: true

      t.timestamps
    end
  end
end
