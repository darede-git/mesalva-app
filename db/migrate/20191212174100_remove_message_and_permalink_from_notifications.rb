class RemoveMessageAndPermalinkFromNotifications < ActiveRecord::Migration[5.2]
  def change
    remove_column :notifications, :message, :string
    remove_column :notifications, :permalink, :string
  end
end
