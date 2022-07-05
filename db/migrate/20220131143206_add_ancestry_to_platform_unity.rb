class AddAncestryToPlatformUnity < ActiveRecord::Migration[5.2]
  def change
    add_column :platform_unities, :ancestry, :string
    add_column :platform_unities, :category, :string
  end
end
