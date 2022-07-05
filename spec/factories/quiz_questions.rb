# frozen_string_literal: true

FactoryBot.define do
  factory :quiz_question, class: 'Quiz::Question' do
    association :form, factory: :quiz_form
    statement 'Qual alternativa correta?'
    question_type 'checkbox'
    description 'explicação da questão'
    sequence :position
    required false

    factory :quiz_question_with_alternative do
      question_type 'radio'
      after :build do |quiz_question|
        quiz_question.alternatives << FactoryBot.build(:quiz_alternative,
                                                       question: quiz_question,
                                                       value: 'A')
        quiz_question.alternatives << FactoryBot.build(:quiz_alternative,
                                                       question: quiz_question,
                                                       value: 'B')
      end
      factory :enem_answer_quiz_question do
        association :form, factory: :quiz_form
      end
    end
  end
end
