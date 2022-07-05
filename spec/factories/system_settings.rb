# frozen_string_literal: true

FactoryBot.define do
  factory :system_setting do
    value some_json_value: 'test'
    sequence :key do |n|
      "my-key-#{n}"
    end
  end
end
