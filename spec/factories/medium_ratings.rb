# frozen_string_literal: true

FactoryBot.define do
  factory :medium_rating do
    association :medium, factory: :medium
    association :user, factory: :user
    value 1
  end
end
