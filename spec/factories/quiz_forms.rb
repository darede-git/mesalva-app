# frozen_string_literal: true

FactoryBot.define do
  factory :quiz_form, class: 'Quiz::Form' do
    name 'Quiz form'
    description 'Quiz form'
    active true
    form_type 'standard'

    trait :answer_grid do
      form_type 'answer_grid'
    end

    factory :quiz_form_with_questions do
      after :build do |quiz_form|
        quiz_form.questions << FactoryBot.build(:quiz_question_with_alternative)
        quiz_form.questions << FactoryBot.build(:quiz_question_with_alternative)
      end
    end
  end
end
