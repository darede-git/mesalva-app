# frozen_string_literal: true

class PostBuyNotificationCampaign < ActiveRecord::Base
  validates_presence_of :package_ids, :notification_type

  scope :active, -> { where(active: true) }
  scope :in_period, lambda {
    where("start_date <= ?", Date.today).where("end_date >= ?", Date.today)
  }
end
