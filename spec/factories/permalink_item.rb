# frozen_string_literal: true

FactoryBot.define do
  factory :permalink_item do
    association :item, factory: :item
    association :permalink, factory: :permalink
  end
end
