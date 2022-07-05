# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    street 'Rua Padre Chagas'
    street_number 79
    street_detail '302'
    neighborhood 'Moinhos de Vento'
    city 'Porto Alegre'
    zip_code '91920-000'
    state 'RS'
    country 'Brasil'
    area_code '11'
    phone_number '979911992'
  end
end
