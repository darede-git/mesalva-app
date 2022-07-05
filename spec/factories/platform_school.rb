# frozen_string_literal: true

FactoryBot.define do
  factory :platform_school do
    name 'example platform school'
    city 'example city'
    association :platform, factory: :platform
  end
end
