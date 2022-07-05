# frozen_string_literal: true

FactoryBot.define do
  factory :lp_page do
    sequence :id, &:to_i
    name 'Some Name'
    data '{"some":"value"}'
    schema '{"some":"value"}'
    created_at '2020-01-01T00:00:01'
    updated_at '2020-01-01T00:00:01'
    trait :enem do
      name 'Enem'
    end
    trait :redacao do
      name 'Redação'
      slug 'enem/redacao'
    end
  end
end
