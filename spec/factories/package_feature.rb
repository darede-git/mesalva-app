# frozen_string_literal: true

FactoryBot.define do
  factory :package_feature do
    package { create(:package_with_price_attributes) }
    feature { create(:feature) }
  end
end
