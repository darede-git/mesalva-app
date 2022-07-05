# frozen_string_literal: true

FactoryBot.define do
  factory :correction_style_criteria do
    sequence(:name) { |n| "Critério I #{n}" }
    values [0, 40, 80, 120, 160, 200]
    association :correction_style, factory: :correction_style
  end
end
