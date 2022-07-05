# frozen_string_literal: true

FactoryBot.define do
  factory :objective do
    sequence :name do |n|
      "Estudar para o ensino médio#{n}"
    end
    education_segment_slug 'ensino-medio'
    active true
    trait :inactive do
      active false
    end
  end
end
