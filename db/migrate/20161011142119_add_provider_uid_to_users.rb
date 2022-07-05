class AddProviderUidToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :facebook_uid, :string
    add_column :users, :google_uid, :string
  end
end
