# frozen_string_literal: true

FactoryBot.define do
  factory :user_counter do
    association :user, factory: :user
  end
end
