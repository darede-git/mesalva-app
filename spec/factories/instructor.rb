# frozen_string_literal: true

FactoryBot.define do
  factory :instructor do
    association :user, factory: :user
  end
end
