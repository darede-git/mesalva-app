class ChangeNotifiedAtOnBookshopGiftPackages < ActiveRecord::Migration[5.2]
  def change
    change_column :bookshop_gift_packages, :notified_at, :timestamp
  end
end
