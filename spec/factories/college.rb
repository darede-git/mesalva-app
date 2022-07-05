# frozen_string_literal: true

FactoryBot.define do
  factory :college do
    sequence(:name) { |n| "college #{n}" }
  end
end
