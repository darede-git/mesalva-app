# frozen_string_literal: true

FactoryBot.define do
  factory :medium, aliases: [:medium_video] do
    sequence :name do |n|
      "medium#{n}"
    end
    medium_type 'video'
    seconds_duration 15
    active true
    difficulty 3
    medium_text 'some medium text'
    sequence(:token) do |n|
      "some-token-#{n}"
    end

    factory :medium_essay do
      medium_type 'essay'
    end

    factory :medium_pdf do
      medium_type 'pdf'
    end

    factory :medium_text do
      medium_type 'text'
    end
    factory :medium_book do
      medium_type 'book'
      attachment Rack::Test::UploadedFile.new(
        File.join(Rails.root, 'spec', 'support', 'uploaders', 'debug-pageflip.zip')
      )
    end

    factory :medium_streaming do
      medium_type 'streaming'
      placeholder 'data:image/jpeg;base64,iVBORw0KGgoAAAANSUhE"\
"UgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP4z8DwHwAFAAH/VscvDQAAAABJRU5ErkJggg=='
    end

    factory :medium_public_document do
      medium_type 'public_document'
    end

    factory :medium_soundcloud do
      medium_type 'soundcloud'
    end

    factory :medium_typeform do
      medium_type 'typeform'
    end

    factory :medium_invalid do
      name ''
    end

    factory :medium_exercise, aliases: [:medium_fixation_exercise] do
      audit_status 'revision_pending'
      correction 'sample correction'
      valid_answers_attributes
      medium_type 'fixation_exercise'
      factory :medium_comprehension_exercise do
        medium_type 'comprehension_exercise'
      end
    end

    factory :medium_essay_video do
      medium_type 'essay_video'
    end

    factory :medium_correction_video do
      medium_type 'correction_video'
    end

    trait :inactive do
      active false
    end

    trait :valid_answers_attributes do
      answers_attributes do
        [{ text: 'alternativa 1', correct: true },
         { text: 'alternativa 2', correct: false },
         { text: 'alternativa 3', correct: false },
         { text: 'alternativa 4', correct: false },
         { text: 'alternativa 5', correct: false }]
      end
    end

    trait :answers_attributes_without_correct_answer do
      answers_attributes do
        [{ text: 'alternativa 1', correct: false },
         { text: 'alternativa 2', correct: false },
         { text: 'alternativa 3', correct: false },
         { text: 'alternativa 4', correct: false },
         { text: 'alternativa 5', correct: false }]
      end
    end

    trait :answers_attributes_with_twice_correct do
      answers_attributes do
        [{ text: 'alternativa 1', correct: true },
         { text: 'alternativa 2', correct: true },
         { text: 'alternativa 3', correct: false },
         { text: 'alternativa 4', correct: false },
         { text: 'alternativa 5', correct: false }]
      end
    end

    trait :answers_attributes_with_one_answer do
      answers_attributes do
        [{ text: 'alternativa 1', correct: true }]
      end
    end

    trait :answers_attributes_without_text do
      answers_attributes do
        [{ text: '', correct: true }]
      end
    end
  end
end
