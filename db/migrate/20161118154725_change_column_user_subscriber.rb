class ChangeColumnUserSubscriber < ActiveRecord::Migration[4.2]
  def change
    rename_column :permalink_events, :user_subscriber, :user_premium
    rename_column :crm_events, :user_subscriber, :user_premium
  end
end
