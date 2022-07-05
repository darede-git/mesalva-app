class RenameColumnDurationInDays < ActiveRecord::Migration[4.2]
  def change
    rename_column :packages, :duration_in_days, :duration
  end
end
