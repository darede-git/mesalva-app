# frozen_string_literal: true

class PostBuyNotificationCampaignWorker
  include Sidekiq::Worker

  def perform
    PostBuyNotificationCampaign.active.in_period.each do |campaign|
      campaign.notified_at = campaign.start_date unless campaign.notified_at

      create_notifications(campaign_eligible_users(campaign),
                           campaign.notification_type)
      campaign.notified_at = Time.now
      campaign.save
    end
  end

  private

  def campaign_eligible_users(campaign)
    ActiveRecord::Base.connection.execute(query(campaign))
  end

  def query(campaign)
    <<~SQL
      SELECT orders.user_id
      FROM orders
      WHERE package_id = ANY(ARRAY#{campaign.package_ids})
      AND status = 2
      AND created_at > \'#{campaign.notified_at}\'
      AND created_at > \'#{campaign.start_date}\'
      AND created_at < \'#{campaign.end_date}\'
    SQL
  end

  def create_notifications(user_ids, notification_type)
    user_ids.each do |user_id|
      Notification.new(
        user_id: user_id['user_id'],
        notification_type: notification_type
      ).save
    end
  end
end
