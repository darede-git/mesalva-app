class CreateSisuNotes < ActiveRecord::Migration[4.2]
  def change
    create_table :sisu_notes do |t|
      t.string :edition
      t.string :ies
      t.string :course
      t.string :grade
      t.string :shift
      t.string :modality
      t.string :note
      t.string :state
      t.string :initials

      t.timestamps null: false
    end
  end
end
