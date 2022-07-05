# frozen_string_literal: true

FactoryBot.define do
  factory :major do
    sequence(:name) { |n| "major #{n}" }
  end
end
