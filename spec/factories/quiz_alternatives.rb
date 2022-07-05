# frozen_string_literal: true

FactoryBot.define do
  factory :quiz_alternative, class: 'Quiz::Alternative' do
    association :question, factory: :quiz_question
    sequence(:description) { |n| "quiz alternative #{n}" }
    sequence(:value) { |n| "quiz_alt_val#{n}" }
    active true
  end
end
