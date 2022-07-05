# frozen_string_literal: true

FactoryBot.define do
  factory :faq do
    name 'Dúvida'
    trait :specific_purpose_faq do
      slug 'enem-e-vestibulares'
    end
    trait :general_purpose_faq do
      name 'Pagamentos'
      slug 'me-salva'
    end
  end
end
