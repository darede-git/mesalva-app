# frozen_string_literal: true

FactoryBot.define do
  factory :enem_answer_grid, class: 'Enem::AnswerGrid' do
    association :user, factory: :user
    association :form_submission,
                factory: :answer_grid_quiz_form_submission_with_answers
    language 'esp'
    exam 'ling'
    color 'blue'
    year 2018

    trait :exam_mat do
      exam 'mat'
      language nil
    end
  end
end
