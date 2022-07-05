class AddAppleUidToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :apple_uid, :string
  end
end
