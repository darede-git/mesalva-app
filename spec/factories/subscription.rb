# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    association :user, factory: :user
    active true
    status 'paid'
    broker_id '74FCA99C15574083AA0E9F400148A68C'

    factory :subscription_pagarme do
      pagarme_subscription { create(:pagarme_subscription) }
    end
  end
end
