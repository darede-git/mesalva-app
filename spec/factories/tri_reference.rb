# frozen_string_literal: true

FactoryBot.define do
  factory :tri_reference do
    association :item, factory: :item
    year 2015
    exam 'linguagens'
    language 'esp'
  end
end
