class RemoveColumnsToMedia < ActiveRecord::Migration[4.2]
  def change
    remove_column :media, :url
    remove_column :media, :file_data
  end
end
