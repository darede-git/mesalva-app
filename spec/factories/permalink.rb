# frozen_string_literal: true

FactoryBot.define do
  factory :permalink do
    sequence :slug do |n|
      "permalink#{n}"
    end

    trait :ends_with_medium do
      medium { create(:medium, slug: "medium1") }
      slug "permalink/medium1"
    end
  end
end
