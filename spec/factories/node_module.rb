# frozen_string_literal: true

FactoryBot.define do
  factory :node_module do
    sequence :name do |n|
      "node_module#{n}"
    end
    sequence(:token) do |n|
      "some-token-#{n}"
    end
    active true
    sequence :position
    node_module_type 'default'
    trait :inactive do
      active false
    end
  end
end
