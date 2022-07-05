# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    association :user, factory: :user
    association :package, factory: :package_valid_with_price
    checkout_method 'bank_slip'
    broker 'pagarme'
    price_paid 100
    status 1
    phone_area '51'
    phone_number '991991919'
    processed false
    email 'email@teste.com'
    cpf '98435565009'
    nationality 'Brasileiro'
    discount_in_cents 0
    expires_at { Time.now + 10.minutes }
    currency 'BRL'
    payment_proof Rack::Test::UploadedFile.new(File.join(Rails.root,
                                                         'spec',
                                                         'support',
                                                         'uploaders',
                                                         'mesalva.png'))
    factory :invalid_play_store_invoice do
      broker_invoice '3270562479901159870.9183678832509714'
    end

    factory :order_valid do
      after :build do |order|
        order.address = FactoryBot.build(:address)
      end

      broker_invoice '02056E6E7E3347B499B94F5F775A014F'

      factory :in_app_order do
        package { create(:package_subscription) }
        broker 'play_store'
        sequence :broker_invoice do |id|
          "GPA.3345-7300-5002-12345..#{id}"
        end
        broker_data do
          {
            "orderId" => "GPA.3345-7300-5002-12345",
            "productId" => "assinatura_me_salva_ensino_medio",
            "packageName" => "com.mesalva",
            "autoRenewing" => "true",
            "purchaseTime" => Time.now.to_i,
            "purchaseState" => "0",
            "purchaseToken" => "ocidakoimmpdlnfdej"
          }
        end
        payments { [create(:payment, :with_play_store_transaction)] }
        trait :expired do
          expires_at { Time.now - 1.day }
        end
      end

      factory :in_app_order_with_original_play_store_transaction_with_new_id do
        package { create(:package_subscription) }
        broker 'play_store'
        sequence :broker_invoice do |id|
          "GPA.3345-7300-5002-1234#{id}"
        end
        broker_data do
          {
            "orderId" => broker_invoice,
            "productId" => "assinatura_me_salva_ensino_medio",
            "packageName" => "com.mesalva",
            "autoRenewing" => "true",
            "purchaseTime" => Time.now.to_i,
            "purchaseState" => "0",
            "purchaseToken" => "ocidakoimmpdlnfdej"
          }
        end
        payments do
          [create(:payment,
                  :with_original_play_store_transaction_with_new_id)]
        end
        trait :expired do
          expires_at { Time.now - 1.day }
        end
      end

      factory :in_app_order_with_original_play_store_transaction_with_old_id do
        package { create(:package_subscription) }
        broker 'play_store'
        sequence :broker_invoice do |id|
          "GPA.$RCAnonymousID:h56t8i5jh90s8jnjrrjri99ewrkdzxc9_123456789#{id}000"
        end
        broker_data do
          {
            "orderId" => broker_invoice,
            "productId" => "assinatura_me_salva_ensino_medio",
            "packageName" => "com.mesalva",
            "autoRenewing" => "true",
            "purchaseTime" => Time.now.to_i,
            "purchaseState" => "0",
            "purchaseToken" => "ocidakoimmpdlnfdej"
          }
        end
        payments { [create(:payment, :with_play_store_transaction)] }
        trait :expired do
          expires_at { Time.now - 1.day }
        end
      end

      factory :in_app_order_with_renewal_1_play_store_transaction do
        package { create(:package_subscription) }
        broker 'play_store'
        sequence :broker_invoice do |id|
          "GPA.3345-7300-5002-12345..#{id}"
        end
        broker_data do
          {
            "orderId" => broker_invoice,
            "productId" => "assinatura_me_salva_ensino_medio",
            "packageName" => "com.mesalva",
            "autoRenewing" => "true",
            "purchaseTime" => Time.now.to_i,
            "purchaseState" => "0",
            "purchaseToken" => "ocidakoimmpdlnfdej"
          }
        end
        payments { [create(:payment, :with_renewal_1_play_store_transaction)] }
        trait :expired do
          expires_at { Time.now - 1.day }
        end
      end

      factory :in_app_order_with_renewal_2_play_store_transaction do
        package { create(:package_subscription) }
        broker 'play_store'
        sequence :broker_invoice do |id|
          "GPA.3345-7300-5002-12345..#{id}"
        end
        broker_data do
          {
            "orderId" => broker_invoice,
            "productId" => "assinatura_me_salva_ensino_medio",
            "packageName" => "com.mesalva",
            "autoRenewing" => "true",
            "purchaseTime" => Time.now.to_i,
            "purchaseState" => "0",
            "purchaseToken" => "ocidakoimmpdlnfdej"
          }
        end
        payments { [create(:payment, :with_renewal_2_play_store_transaction)] }
        trait :expired do
          expires_at { Time.now - 1.day }
        end
      end

      factory :in_app_order_with_original_app_store_transaction_with_new_id do
        package { create(:package_subscription) }
        broker 'app_store'
        sequence :broker_invoice do |id|
          "00112233445566#{id}"
        end
        broker_data do
          {
            "orderId" => broker_invoice,
            "productId" => "assinatura_me_salva_ensino_medio",
            "packageName" => "com.mesalva",
            "autoRenewing" => "true",
            "purchaseTime" => Time.now.to_i,
            "purchaseState" => "0",
            "purchaseToken" => "ocidakoimmpdlnfdej"
          }
        end
        payments { [create(:payment, :with_original_app_store_transaction_with_new_id)] }
        trait :expired do
          expires_at { Time.now - 1.day }
        end
      end

      factory :in_app_order_with_original_app_store_transaction_with_old_id do
        package { create(:package_subscription) }
        broker 'app_store'
        sequence :broker_invoice do |id|
          "GPA.$RCAnonymousID:h56t8i5jh90s8jnjrrjri99ewrkdzxc9_123456789#{id}000"
        end
        broker_data do
          {
            "orderId" => broker_invoice,
            "productId" => "assinatura_me_salva_ensino_medio",
            "packageName" => "com.mesalva",
            "autoRenewing" => "true",
            "purchaseTime" => Time.now.to_i,
            "purchaseState" => "0",
            "purchaseToken" => "ocidakoimmpdlnfdej"
          }
        end
        payments { [create(:payment, :with_app_store_transaction)] }
        trait :expired do
          expires_at { Time.now - 1.day }
        end
      end

      factory :in_app_order_with_renewal_1_app_store_transaction do
        package { create(:package_subscription) }
        broker 'app_store'
        sequence :broker_invoice do |id|
          "11223344556677..#{id}"
        end
        broker_data do
          {
            "orderId" => broker_invoice,
            "productId" => "assinatura_me_salva_ensino_medio",
            "packageName" => "com.mesalva",
            "autoRenewing" => "true",
            "purchaseTime" => Time.now.to_i,
            "purchaseState" => "0",
            "purchaseToken" => "ocidakoimmpdlnfdej"
          }
        end
        payments { [create(:payment, :with_renewal_1_app_store_transaction)] }
        trait :expired do
          expires_at { Time.now - 1.day }
        end
      end

      factory :in_app_order_with_renewal_2_app_store_transaction do
        package { create(:package_subscription) }
        broker 'app_store'
        sequence :broker_invoice do |id|
          "22334455667788..#{id}"
        end
        broker_data do
          {
            "orderId" => broker_invoice,
            "productId" => "assinatura_me_salva_ensino_medio",
            "packageName" => "com.mesalva",
            "autoRenewing" => "true",
            "purchaseTime" => Time.now.to_i,
            "purchaseState" => "0",
            "purchaseToken" => "ocidakoimmpdlnfdej"
          }
        end
        payments { [create(:payment, :with_renewal_2_app_store_transaction)] }
        trait :expired do
          expires_at { Time.now - 1.day }
        end
      end

      factory :order_with_expiration_date do
        expires_at { Time.now + 10.minutes }
        factory :subscription_order do
          subscription { create(:subscription) }
        end
      end

      factory :order_with_discount do
        discount { create(:discount) }
      end

      factory :order_expired_date do
        expires_at { Time.now - 10.minutes }

        factory :order_expired do
          status 2
        end

        factory :order_subscription_expired, aliases: [:expired_order] do
          user { create(:user) }
          subscription { create(:subscription, user_id: user.id) }
          status 2
        end
      end
      factory :pending_order, aliases: [:oneshot_bank_slip_order] do
        status 1
      end
      factory :pending_credit_card, aliases: [:oneshot_credit_card_order] do
        status 1
        checkout_method 'credit_card'
      end
      factory :paid_order do
        status 2
      end
      factory :canceled_order do
        status 3
      end
      factory :expired_status_order do
        status 4
      end
      factory :invalid_order do
        status 5
      end
      factory :refunded_order do
        status 6
      end
      factory :order_not_found do
        status 7
      end
      factory :order_credit_card do
        checkout_method 'credit_card'
      end
      factory :order_with_pagarme_subscription do
        checkout_method 'credit_card'
        broker 'pagarme'
        association :package, factory: :to_pagarme_subscription
        subscription { create(:subscription_pagarme) }
      end
    end
    factory :order_with_address_attributes do
      address_attributes do
        { street: 'Rua Padre Chagas',
          street_number: 79,
          street_detail: '302',
          neighborhood: 'Moinhos de Vento',
          city: 'Porto Alegre',
          zip_code: '91920-000',
          state: 'RS',
          country: 'Brasil' }
      end
    end
  end

  trait :credit_card do
    checkout_method 'credit_card'
  end

  trait :paid do
    status 2
  end

  trait :with_utm_attributes do
    utm_attributes do
      {
        utm_source: 'enem',
        utm_medium: '320banner',
        utm_term: 'matematica',
        utm_content: '',
        utm_campaign: 'mkt'
      }
    end
  end

  trait :with_utm_buzzlead do
    utm_attributes do
      {
        utm_source: 'buzzlead',
        utm_medium: 'link_pessoal',
        utm_term: 'indique_um_amigo',
        utm_content: 'KXROBO',
        utm_campaign: 'referral'
      }
    end
  end

  trait :with_utm_attributes_blank do
    utm_attributes do
      {
        utm_source: '',
        utm_medium: '',
        utm_term: '',
        utm_content: '',
        utm_campaign: ''
      }
    end
  end
end
