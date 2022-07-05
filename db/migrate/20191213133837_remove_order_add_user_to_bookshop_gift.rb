class RemoveOrderAddUserToBookshopGift < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :bookshop_gifts, :orders
    remove_column :bookshop_gifts, :order_id, :bigint
    add_column :bookshop_gifts, :user_id, :bigint
    add_foreign_key :bookshop_gifts, :users
  end
end
