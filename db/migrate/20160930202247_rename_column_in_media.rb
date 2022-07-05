class RenameColumnInMedia < ActiveRecord::Migration[4.2]
  def change
    rename_column :media, :length, :seconds_duration
  end
end
