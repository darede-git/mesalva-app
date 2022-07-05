class AddsAppReferenceToPackages < ActiveRecord::Migration[4.2]
  def change
    add_column :packages, :play_store_product_id, :integer
    add_column :packages, :apple_store_product_id, :integer
  end
end
