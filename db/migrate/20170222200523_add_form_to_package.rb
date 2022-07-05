class AddFormToPackage < ActiveRecord::Migration[4.2]
  def change
    add_column :packages, :form, :string
  end
end
