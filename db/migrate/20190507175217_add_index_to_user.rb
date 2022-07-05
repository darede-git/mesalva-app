class AddIndexToUser < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :facebook_uid
    add_index :users, :google_uid
  end
end
