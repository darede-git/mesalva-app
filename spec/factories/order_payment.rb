# frozen_string_literal: true

FactoryBot.define do
  factory :payment, class: 'OrderPayment' do
    association :order, factory: :order_valid
    payment_method 'card'
    amount_in_cents 1000
    card_token 'some-card-token'
    installments 1

    trait :card do
      payment_method 'card'
    end

    trait :bank_slip do
      payment_method 'bank_slip'
      pdf 'https://pagar.me'
      barcode '1234 5678'
    end

    trait :with_pagarme_transaction do
      pagarme_transaction { create(:pagarme_transaction) }
    end

    trait :with_play_store_transaction do
      play_store_transaction { create(:play_store_transaction) }
    end

    trait :with_original_play_store_transaction_with_new_id do
      play_store_transaction do
        create(:play_store_transaction,
               :original_play_store_transaction_with_new_id)
      end
    end

    trait :with_renewal_1_play_store_transaction do
      play_store_transaction do
        create(:play_store_transaction,
               :renewal_1_play_store_transaction)
      end
    end

    trait :with_renewal_2_play_store_transaction do
      play_store_transaction do
        create(:play_store_transaction,
               :renewal_1_play_store_transaction)
      end
    end

    trait :with_app_store_transaction do
      app_store_transaction { create(:app_store_transaction) }
    end

    trait :with_original_app_store_transaction_with_new_id do
      app_store_transaction do
        create(:app_store_transaction,
               :original_app_store_transaction_with_new_id)
      end
    end

    trait :with_renewal_1_app_store_transaction do
      app_store_transaction do
        create(:app_store_transaction,
               :renewal_1_app_store_transaction)
      end
    end

    trait :with_renewal_2_app_store_transaction do
      app_store_transaction do
        create(:app_store_transaction,
               :renewal_1_app_store_transaction)
      end
    end
  end
end
