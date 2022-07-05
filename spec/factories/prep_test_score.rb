# frozen_string_literal: true

FactoryBot.define do
  factory :prep_test_score do
    association :user, factory: :user
    score 100.10
    permalink_slug 'enem-e-vestibulares/simulados/simulado-20181/enem20181hum'
    submission_token 'MjAxNy0wMy0yMyAxMzoxMzowOCArMDAwMA'
  end
end
