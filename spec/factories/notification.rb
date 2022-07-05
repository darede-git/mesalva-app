# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    association :user, factory: :user
    notification_type "essay_draft_created_but_not_sent"

    trait :expired do
      expires_at Time.now - 1.day
    end
  end
end
