# frozen_string_literal: true

FactoryBot.define do
  factory :school do
    sequence(:name) { |n| "school #{n}" }
    uf 'RS'
    city 'Porto Alegre'
  end
end
