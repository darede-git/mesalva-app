# frozen_string_literal: true

FactoryBot.define do
  factory :notification_event do
    association :user, factory: :user
    association :notification, factory: :notification
    read true
  end
end
