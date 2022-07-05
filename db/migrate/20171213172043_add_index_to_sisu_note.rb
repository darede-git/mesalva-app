class AddIndexToSisuNote < ActiveRecord::Migration[4.2]
  def change
    add_index :sisu_notes, :course
    add_index :sisu_notes, :state
    add_index :sisu_notes, :modality
  end
end
