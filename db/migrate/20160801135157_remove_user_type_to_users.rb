class RemoveUserTypeToUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :user_type
  end
end
