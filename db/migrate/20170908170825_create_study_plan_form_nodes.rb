class CreateStudyPlanFormNodes < ActiveRecord::Migration[4.2]
  def change
    create_table :study_plan_form_nodes do |t|
      t.belongs_to :quiz_form, index: true, foreign_key: { on_delete: :cascade }
      t.belongs_to :node, index: true, foreign_key: { on_delete: :cascade }

      t.timestamps null: false
    end
  end
end
