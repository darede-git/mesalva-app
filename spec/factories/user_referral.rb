# frozen_string_literal: true

FactoryBot.define do
  factory :user_referral do
    association :user, factory: :user

    trait :checked_yesterday do
      last_checked Date.yesterday
    end
  end
end
