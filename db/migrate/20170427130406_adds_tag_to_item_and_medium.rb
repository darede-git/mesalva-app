class AddsTagToItemAndMedium < ActiveRecord::Migration[4.2]
  def change
    add_column :media, :tag, :string, array: true
    add_column :items, :tag, :string, array: true
  end
end
