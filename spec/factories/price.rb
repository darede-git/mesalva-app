# frozen_string_literal: true

FactoryBot.define do
  factory :price do
    value 10.00
    active true
    price_type 'credit_card'
    currency 'BRL'
    trait :credit_card do
      price_type 'credit_card'
    end
    trait :bank_slip do
      price_type 'bank_slip'
    end
    trait :play_store do
      price_type 'play_store'
    end
    factory :dolar_price do
      currency 'USD'
    end
  end
end
