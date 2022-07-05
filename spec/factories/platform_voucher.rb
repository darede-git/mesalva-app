# frozen_string_literal: true

FactoryBot.define do
  factory :platform_voucher do
    sequence :token do |n|
      "token - #{n}"
    end
    association :package, factory: :package_valid_with_price
    association :platform, factory: :platform

    trait :already_in_use do
      association :user, factory: :user
    end
  end
end
