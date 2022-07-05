# frozen_string_literal: true

FactoryBot.define do
  factory :permalink_medium do
    association :medium, factory: :medium
    association :permalink, factory: :permalink
  end
end
