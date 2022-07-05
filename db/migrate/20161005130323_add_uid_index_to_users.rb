class AddUidIndexToUsers < ActiveRecord::Migration[4.2]
  def change
    add_index :users, :uid
  end
end
