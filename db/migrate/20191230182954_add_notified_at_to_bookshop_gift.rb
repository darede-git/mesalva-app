class AddNotifiedAtToBookshopGift < ActiveRecord::Migration[5.2]
  def change
    add_column :bookshop_gifts, :user_notified_at, :date
  end
end
