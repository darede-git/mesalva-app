class RenameJustification < ActiveRecord::Migration[4.2]
  def change
    rename_column :answers, :justification, :explanation
  end
end
