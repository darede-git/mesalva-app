class AddsPackageNameToCrmAttributes < ActiveRecord::Migration[4.2]
  def change
  	add_column :crm_events, :package_name, :string
  	add_column :crm_events, :package_slug, :string
  end
end
