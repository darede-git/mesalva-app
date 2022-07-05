# frozen_string_literal: true

FactoryBot.define do
  factory :quiz_form_submission, class: 'Quiz::FormSubmission' do
    association :form, factory: :quiz_form
    association :user, factory: :user
  end

  factory :quiz_form_submission_with_answers,
          parent: :quiz_form_submission do |_form_submission|
    after :build do |fs|
      fs.answers << create(:quiz_answer, form_submission: fs)
    end
  end
end
