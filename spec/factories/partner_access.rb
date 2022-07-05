# frozen_string_literal: true

FactoryBot.define do
  factory :partner_access do
    cpf "00011122233"
    birth_date Date.yesterday
    partner "Zilla Corp"
  end
end
