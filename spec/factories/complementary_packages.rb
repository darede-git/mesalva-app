# frozen_string_literal: true

FactoryBot.define do
  factory :complementary_package do
    association :package_id, factory: :package_valid_with_price
    association :child_package_id, factory: :package_valid_with_price
    position 1
  end
end
