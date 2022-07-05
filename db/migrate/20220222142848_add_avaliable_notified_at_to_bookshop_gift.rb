class AddAvaliableNotifiedAtToBookshopGift < ActiveRecord::Migration[5.2]
  def change
    rename_column :bookshop_gifts, :user_notified_at, :pending_notified_at
    add_column :bookshop_gifts, :avaliable_notified_at, :datetime
  end
end
