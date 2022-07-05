# frozen_string_literal: true

FactoryBot.define do
  factory :platform_unity do
    association :platform, factory: :platform

    sequence :name do |n|
      "example platform #{n}"
    end
    uf "example platform"
    city "example platform"
  end
end
