# frozen_string_literal: true

FactoryBot.define do
  factory :canonical_uri do
    sequence :slug do |n|
      "slug#{n}"
    end
  end
end
