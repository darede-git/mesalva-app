class CreateContentTeacherItems < ActiveRecord::Migration[5.2]
  def change
    create_table :content_teacher_items do |t|
      t.references :content_teacher, foreign_key: true
      t.references :item, foreign_key: true

      t.timestamps
    end
  end
end
