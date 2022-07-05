class AddDownloadableToItem < ActiveRecord::Migration[4.2]
  def change
    add_column :items, :downloadable, :boolean, default: true, null: false
  end
end
