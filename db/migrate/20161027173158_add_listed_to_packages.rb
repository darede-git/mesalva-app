class AddListedToPackages < ActiveRecord::Migration[4.2]
  def change
    add_column :packages, :listed, :boolean, default: false, null: false
  end
end
