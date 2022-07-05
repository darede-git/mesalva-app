# frozen_string_literal: true

FactoryBot.define do
  factory :post_buy_notification_campaign do
    start_date Time.now
    end_date Time.now + 1.month
    active true
    notified_at Time.now - 1.day

    notification_type 'back_to_classes_campaign'
  end
end
