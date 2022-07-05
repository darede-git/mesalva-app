# frozen_string_literal: true

FactoryBot.define do
  factory :bookshop_gift do
    coupon '12345'
    association :bookshop_gift_package, factory: :bookshop_gift_package
    coupon_available false

    trait :available do
      coupon_available true
    end

    trait :to_be_available do
      pending_notified_at Date.today - 7.days
    end

    trait :with_order do
      association :order, factory: :paid_order
    end

    trait :used do
      coupon_available true
      association :order, factory: :paid_order
    end
  end
end
