# frozen_string_literal: true

FactoryBot.define do
  factory :mentoring do
    sequence :title do |n|
      "example title #{n}"
    end
    active true
    rating 5
    association :user, factory: :user
    association :content_teacher, factory: :content_teacher
    comment "example comment"
    starts_at Time.now - 1.minute
    simplybook_id 1

    trait :private_class_chemistry_yesterday do
      starts_at Date.yesterday
      title 'Aula particular de Química'
      category 'private_class'
    end

    trait :mentoring_math_tomorrow do
      active false
      starts_at Date.tomorrow
      title 'Mentoria de Matemática'
      category 'mentoring'
    end
  end
end
