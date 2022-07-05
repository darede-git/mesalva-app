# frozen_string_literal: true

FactoryBot.define do
  factory :crm_event do
    event_name 'checkout_view'
    user_id 1
    education_segment nil
    order_price nil
    order_payment_type nil
    order_id nil
    user_email 'user1@mesalva.com'
    user_name 'Me Salva!'
    user_premium false
    user_objective nil
    user_objective_id nil
    location '41.12,-71.34'
    client 'ANDROID'
    device 'iPhone 6S'
    user_agent 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, /' \
      'like Gecko) Chrome/41.0.2228.0 Safari/537.36'

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
end
