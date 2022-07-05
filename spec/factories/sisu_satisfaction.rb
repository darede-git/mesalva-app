# frozen_string_literal: true

FactoryBot.define do
  factory :sisu_satisfaction do
    association :user, factory: :user
    satisfaction true
    plan 'Entrar em uma universidade federal'
  end
end
