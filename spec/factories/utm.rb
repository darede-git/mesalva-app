# frozen_string_literal: true

FactoryBot.define do
  factory :utm do
    trait :desafio_me_salva do
      utm_source { 'indicacao-desafio' }
      utm_medium { 'link_pessoal' }
      utm_campaign { 'desafio-enem-do-zero' }
      referenceable_type { 'CrmEvent' }
    end

    trait :quarantine do
      utm_source { 'quarentena-covid19' }
      utm_medium { 'link_pessoal' }
      utm_campaign { 'covid19' }
      referenceable_type { 'CrmEvent' }
    end
  end
end
