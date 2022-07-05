class CreateStudyPlans < ActiveRecord::Migration[4.2]
  def change
    create_table :study_plans do |t|
      t.belongs_to :user, index: true, foreign_key: { on_delete: :cascade }
      t.belongs_to :quiz_form_submission, index: true, foreign_key: { on_delete: :cascade }

      t.timestamps null: false
    end
  end
end
