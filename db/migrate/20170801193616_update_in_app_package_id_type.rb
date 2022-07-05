class UpdateInAppPackageIdType < ActiveRecord::Migration[4.2]
  def change
    change_column :packages, :play_store_product_id, :string
    change_column :packages, :app_store_product_id, :string
  end
end
