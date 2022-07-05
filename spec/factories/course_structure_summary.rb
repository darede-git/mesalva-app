# frozen_string_literal: true

FactoryBot.define do
  factory :course_structure_summary do
    name "Extensivo ENEM"
    slug "extensivo-enem"
    active true
    listed true

    trait :different_slug do
      slug "intensivo-enem"
    end
  end
end
