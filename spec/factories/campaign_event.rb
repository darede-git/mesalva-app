# frozen_string_literal: true

FactoryBot.define do
  factory :campaign_event do
    association :user, factory: :user
    association :invited_by, factory: :user
    campaign_name 'campaign-example'
  end

  trait :first_event do
    event_name 'event-sign-up'
  end

  trait :second_event do
    event_name 'event-simulado'
  end
end
