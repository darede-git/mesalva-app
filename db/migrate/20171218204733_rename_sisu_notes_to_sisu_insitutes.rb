class RenameSisuNotesToSisuInsitutes < ActiveRecord::Migration[4.2]
  def change
    rename_table :sisu_notes, :sisu_institutes

    rename_column :sisu_institutes, :note, :passing_score
  end
end
