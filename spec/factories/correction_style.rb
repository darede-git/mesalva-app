# frozen_string_literal: true

FactoryBot.define do
  factory :correction_style do
    sequence(:name) { |n| "UFRGS#{n}" }
  end
end
