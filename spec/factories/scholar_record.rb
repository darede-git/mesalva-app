# frozen_string_literal: true

FactoryBot.define do
  factory :scholar_record do
    association :user, factory: :user
    education_level 'Ensino Médio'
    level_concluded false
    study_phase 3

    trait :inactive do
      active false
    end

    trait :with_school do
      association :school, factory: :school
    end

    trait :with_college do
      association :college, factory: :college
      association :major, factory: :major
    end
  end
end
