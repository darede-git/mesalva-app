# frozen_string_literal: true

FactoryBot.define do
  factory :discount do
    name 'Desconto 20%'
    starts_at { Time.now - 1.hour }
    expires_at { Time.now + 10.hour }
    percentual 20
    code 'Desconto20'
    packages %w[1 2]
    description 'Desconto de 20% no pacote 1 e 2'
    only_customer false
    trait :expired do
      starts_at { Time.now - 2.hour }
      expires_at { Time.now - 1.hour }
    end

    trait :for_all_packages do
      packages ['*']
    end

    trait :upsell do
      upsell_packages ['1']
    end

    factory :discount_only_customer do
      only_customer true
      name 'Desconto 30%'
      code 'FIDELIDADE30'
      description 'Desconto de fidelidade de 30% em qualquer pacote'
      percentual 30
    end
  end
end
