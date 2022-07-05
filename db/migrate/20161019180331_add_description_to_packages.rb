class AddDescriptionToPackages < ActiveRecord::Migration[4.2]
  def change
    add_column :packages, :description, :text
    add_column :packages, :info, :text, array: true
  end
end
