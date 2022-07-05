# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    sequence(:name) { |n| "User #{n}" }
    sequence(:slug) { |n| "user-#{n}" }
    role_type 'admin'
  end
end
