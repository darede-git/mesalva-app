# frozen_string_literal: true

FactoryBot.define do
  factory :enem_answer, class: 'Enem::Answer' do
    association :answer_grid, factory: :enem_answer_grid
    association :question, factory: :quiz_question
    association :alternative, factory: :quiz_alternative

    value "A"
    correct_value "A"
    correct true
  end
end
