class AddIndexToUsersConfirmationToken < ActiveRecord::Migration[4.2]
  def change
    add_index :users, :confirmation_token
  end
end
