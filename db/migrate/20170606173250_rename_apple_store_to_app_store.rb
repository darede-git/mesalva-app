class RenameAppleStoreToAppStore < ActiveRecord::Migration[4.2]
  def change
    rename_column :packages, :apple_store_product_id, :app_store_product_id
  end
end
