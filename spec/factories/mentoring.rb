# frozen_string_literal: true

FactoryBot.define do
  factory :mentoring do
    sequence :title do |n|
      "example title #{n}"
    end
    status 1
    rating 5
    association :user, factory: :user
    association :content_teacher, factory: :content_teacher
    comment "example comment"
    starts_at Time.now - 1.minute
    simplybook_id 1
  end
end
