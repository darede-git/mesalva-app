# frozen_string_literal: true

FactoryBot.define do
  factory :lp_block do
    sequence :id, &:to_i
    sequence :name do |name|
      "some name #{name}"
    end
    schema '{"some":"schema"}'
    created_at '2020-01-01T00:00:01'
    updated_at '2020-01-01T00:00:01'
    trait :hero do
      id 100
      name 'HeroEnem'
    end
    trait :faq do
      id 200
      name 'Faq'
    end
  end
end
