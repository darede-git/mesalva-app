class RenameUserStatusToPremiumStatus < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :status, :premium_status
  end
end
