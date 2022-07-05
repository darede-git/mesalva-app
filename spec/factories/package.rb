# frozen_string_literal: true

FactoryBot.define do
  factory :package do
    sequence(:name) { |n| "Enem Semestral#{n}" }
    sequence(:slug) { |n| "enem-semestral#{n}" }
    sequence(:sku) { |_n| "enem-semestral" }
    duration 6
    max_payments 1
    play_store_product_id 'assinatura_me_salva_engenharia'
    app_store_product_id 'assinatura_me_salva_engenharia'
    expires_at nil
    description 'Enem semestral 6 meses'
    info ['info 1', 'info 2', 'info 3']
    label %w[extensivo-introducao extensivo-medicina]
    education_segment_slug 'enem-e-vestibulares'
    sales_platforms %w[web ios android]
    essay_credits 10
    private_class_credits 0
    unlimited_essay_credits false
    complementary false
    association :tangible_product
    tangible_product_discount_percent 10.0
    node_ids do
      create(:node).id
    end
    sequence(:iugu_plan_identifier) { |n| "enem-semestral#{n}" }
    subscription false
    factory :package_valid_with_price do
      max_pending_essay 0
      after :build do |package|
        package.prices << FactoryBot.build(:price, :credit_card, package: nil)
        package.prices << FactoryBot.build(:price, :bank_slip, package: nil)
        package.prices << FactoryBot.build(:price, :play_store, package: nil)
      end
      factory :package_with_expires_at do
        expires_at Time.now + 30.minutes
        duration nil
      end
      factory :package_with_duration do
        expires_at nil
        duration 6
      end
      factory :package_subscription do
        subscription true
      end
      trait :active do
        active true
      end
      trait :inactive do
        active false
      end
      factory :to_pagarme_subscription do
        subscription true
        pagarme_plan_id 171_152
      end
    end
    factory :package_with_expires_at_and_duration do
      expires_at Time.now + 10.minutes
    end
    factory :package_invalid do
      expires_at nil
      duration nil
    end
    factory :package_with_price_attributes do
      prices_attributes do
        [{ price_type: 'credit_card',
           value: 10.00,
           currency: 'BRL' }]
      end
      bookshop_gift_packages_attributes do
        [{ active: false, bookshop_link: 'teste' }]
      end
    end

    trait :with_private_class_credits do
      private_class_credits 10
    end

    trait :study_plan do
      after :build do |package|
        package.features << FactoryBot.build(:feature, :study_plan)
      end
    end

    trait :with_feature do
      after :build do |package|
        package.features << FactoryBot.build(:feature)
      end
    end
    package_type 'Básico'
  end
end
