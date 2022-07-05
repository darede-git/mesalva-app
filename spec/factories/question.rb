# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title 'Que conteúdos estão no plano Intensivo ENEM?'
    answer 'Matemática, Ciências, Linguagens, Redação e Humanas'
    created_by 'admin@mesalva.com'
    updated_by 'admin@mesalva.com'
    image 'data:image/jpeg;base64,iVBORw0KGgoAAAANSUhE"\
 "UgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP4z8DwHwAFAAH/VscvDQAAAABJRU5ErkJggg=='
    trait :general_question do
      association :faq, factory: %i[faq general_purpose_faq]
    end

    trait :specific_question do
      association :faq, factory: %i[faq specific_purpose_faq]
    end
  end
end
