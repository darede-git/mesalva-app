# frozen_string_literal: true

FactoryBot.define do
  factory :user_setting do
    association :user, factory: :user

    value some_json_value: 'test'

    sequence :key do |n|
      "my-key-#{n}"
    end
  end
end
