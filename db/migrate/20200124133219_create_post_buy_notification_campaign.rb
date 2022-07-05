
class CreatePostBuyNotificationCampaign < ActiveRecord::Migration[5.2]
  def change
    create_table :post_buy_notification_campaigns do |t|
      t.date :start_date
      t.date :end_date
      t.date :notified_at
      t.boolean :active, default: true
      t.string :notification_type
      t.integer :package_ids, array: true
    end
  end
end
