class RenameAlternativeToAnswer < ActiveRecord::Migration[4.2]
  def change
    rename_table :alternatives, :answers
  end
end
