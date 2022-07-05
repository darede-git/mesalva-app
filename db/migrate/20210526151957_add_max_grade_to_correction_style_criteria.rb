# frozen_string_literal: true

class AddMaxGradeToCorrectionStyleCriteria < ActiveRecord::Migration[5.2]
  def change
    add_column :correction_style_criteria, :max_grade, :float, array: true, default: []
  end
end
