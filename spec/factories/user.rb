# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence :uid, &:to_s
    name 'Me Salva!'
    sequence :email do |n|
      "user#{n}@mesalva.com"
    end
    iugu_customer_id 'C9D0A8F68F7F415A87CDC55EC11A7242'
    active true
    profile nil

    factory :facebook_user do
      provider 'facebook'
      uid '123'
      facebook_uid '123'
    end

    factory :multiple_provider_user do
      facebook_uid '123'
      google_uid '456'
    end

    factory :intercom_user, class: OpenStruct do
      sequence :id
      sequence(:name) { |n|  "Intercom User#{n}" }
      sequence(:email) { |n| "intercom_user#{n}@mesalva.com" }
      sequence(:crm_email) { |n| "intercom_user#{n}@mesalva.com" }
    end

    factory :user_with_address_attributes do
      address_attributes do
        {
          street: 'Rua Padre Chagas',
          street_number: 79,
          street_detail: '302',
          neighborhood: 'Moinhos de Vento',
          city: 'Porto Alegre',
          zip_code: '91920-000',
          state: 'RS',
          country: 'Brasil',
          area_code: '11',
          phone_number: '979911992'
        }
      end
    end
  end
end
