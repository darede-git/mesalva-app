class ChangeStudyPlanOffsetDefaultValue < ActiveRecord::Migration[5.2]
  def change
    change_column_default :study_plans, :offset, from: 1, to: 0
  end
end
