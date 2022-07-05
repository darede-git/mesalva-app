class AddUserAppleAndTokenIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :apple_uid
    add_index :users, :token
  end
end
