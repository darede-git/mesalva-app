# frozen_string_literal: true

FactoryBot.define do
  factory :app_store_transaction do
    sequence :transaction_id do |id|
      "$RCAnonymousID:h56t8i5jh90s8jnjrrjri99ewrkdzxc9_111111111#{id}000"
    end
    metadata do
      {
        "product_id" => "assinatura_me_salva_enem_e_vestibulares",
        "transaction_id" => "330000316001613",
        "expires_date_ms" => "1523029143575",
        "purchase_date_ms" => "1520354343575",
        "original_transaction_id" => "330000316001613",
        "original_purchase_date_ms" => "1520354346094"
      }
    end
  end
  trait :original_app_store_transaction_with_new_id do
    transaction_id "001122334455667"
    metadata do
      {
        "orderId" => transaction_id,
        "product_id" => "assinatura_me_salva_ensino_medio",
        "packageName" => "com.mesalva",
        "autoRenewing" => "true",
        "purchaseTime" => Time.now.to_i,
        "purchaseState" => "0",
        "purchaseToken" => "ocidakoimmpdlnfdej",
        "transaction_id" => transaction_id,
        "original_transaction_id" => transaction_id,
        "app_user_id" => "$RCAnonymousID:h56t8i5jh90s8jnjrrjri99ewrkdzxc9",
        "original_app_user_id" => "$RCAnonymousID:h56t8i5jh90s8jnjrrjri99ewrkdzxc9",
        "purchased_at_ms" => 1_625_880_599_870,
        "type" => "INITIAL_PURCHASE",
        "transaction_id_old" => "GPA.$RCAnonymousID:h56t8i5jh90s8jnjrrjri99ewrkdzxc9_1625880599000",
        "purchase_index" => 0
      }
    end
  end
  trait :renewal_1_app_store_transaction do
    transaction_id "001122334455667..1"
    metadata do
      {
        "orderId" => transaction_id,
        "product_id" => "assinatura_me_salva_ensino_medio",
        "packageName" => "com.mesalva",
        "autoRenewing" => "true",
        "purchaseTime" => Time.now.to_i,
        "purchaseState" => "0",
        "purchaseToken" => "ocidakoimmpdlnfdej",
        "transaction_id" => transaction_id,
        "original_transaction_id" => transaction_id[0..23],
        "app_user_id" => "$RCAnonymousID:h56t8i5jh90s8jnjrrjri99ewrkdzxc9",
        "original_app_user_id" => "$RCAnonymousID:h56t8i5jh90s8jnjrrjri99ewrkdzxc9",
        "purchased_at_ms" => 1_625_880_599_870,
        "type" => "RENEWAL",
        "transaction_id_old" => "GPA.$RCAnonymousID:h56t8i5jh90s8jnjrrjri99ewrkdzxc9_1625880599000",
        "purchase_index" => (transaction_id[26..-1].to_i + 1)
      }
    end
  end
  trait :renewal_2_app_store_transaction do
    transaction_id "001122334455667..2"
    metadata do
      {
        "orderId" => transaction_id,
        "product_id" => "assinatura_me_salva_ensino_medio",
        "packageName" => "com.mesalva",
        "autoRenewing" => "true",
        "purchaseTime" => Time.now.to_i,
        "purchaseState" => "0",
        "purchaseToken" => "ocidakoimmpdlnfdej",
        "transaction_id" => transaction_id,
        "original_transaction_id" => transaction_id[0..23],
        "app_user_id" => "$RCAnonymousID:h56t8i5jh90s8jnjrrjri99ewrkdzxc9",
        "original_app_user_id" => "$RCAnonymousID:h56t8i5jh90s8jnjrrjri99ewrkdzxc9",
        "purchased_at_ms" => 1_625_880_599_870,
        "type" => "RENEWAL",
        "transaction_id_old" => "GPA.$RCAnonymousID:h56t8i5jh90s8jnjrrjri99ewrkdzxc9_1625880599000",
        "purchase_index" => (transaction_id[26..-1].to_i + 1)
      }
    end
  end
end
