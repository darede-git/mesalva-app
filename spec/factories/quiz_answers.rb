# frozen_string_literal: true

FactoryBot.define do
  factory :quiz_answer, class: 'Quiz::Answer' do
    association :question, factory: :quiz_question_with_alternative
    association :alternative, factory: :quiz_alternative
    association :form_submission, factory: :quiz_form_submission
    value 'answer value'
  end
end
