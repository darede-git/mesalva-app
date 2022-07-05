# frozen_string_literal: true

FactoryBot.define do
  factory :search_datum do
    sequence :name do |n|
      "search_datum#{n}"
    end
  end
end
