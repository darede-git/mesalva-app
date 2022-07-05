# frozen_string_literal: true

FactoryBot.define do
  factory :correction_style_criteria_check do
    name 'teste checkbox'
    association :correction_style_criteria, factory: :correction_style_criteria
  end
end
