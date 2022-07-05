class AddFacebookAdsInfosToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :facebook_ads_infos, :json, default: {}
  end
end
