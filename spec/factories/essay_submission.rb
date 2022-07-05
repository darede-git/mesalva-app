# frozen_string_literal: true

# rubocop:disable Style/MixinUsage
include ActionDispatch::TestProcess
# rubocop:enable Style/MixinUsage

FactoryBot.define do
  factory :essay_submission do
    association :permalink, factory: :permalink
    association :user, factory: :user
    correction_style { create(:correction_style) }
    correction_type 'redacao-padrao'
    feedback nil
    grades { { grade_1: 200, grade_2: 120, grade_3: 160, grade_4: 120, grade_5: nil } }
    uncorrectable_message nil
    draft do
      '{
        "steps" => {
          "1" => {
            "description" => "descrição 1",
            "info" => "info1",
            "text" => "texto 1",
            "title" => "Titulo 1"
          },
          "2" => {
            "description" => "descrição 2",
            "info" => "info2",
            "text" => "texto 2",
            "title" => "Titulo 2"
          }
        }
      }'
    end
    draft_feedback nil
    factory :essay_submission_with_essay do
      essay Rack::Test::UploadedFile.new(File.join(Rails.root,
                                                   'spec',
                                                   'support',
                                                   'uploaders',
                                                   'mesalva.png'))

      trait :correcting do
        status 2
      end

      trait :uncorrectable do
        status 6
        uncorrectable_message 'Imagem quebrada'
      end

      trait :corrected_custom do
        correction_type 'redacao-personalizada'
        status 3
        feedback 'feedback da redação'
        draft_feedback 'feedback do plano de texto'
      end

      trait :delivered do
        correction_type 'redacao-personalizada'
        status 4
        feedback 'feedback da redação'
        draft_feedback 'feedback do plano de texto'
      end
    end
  end
end
