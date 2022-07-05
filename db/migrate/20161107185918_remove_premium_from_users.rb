class RemovePremiumFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :premium
  end
end
