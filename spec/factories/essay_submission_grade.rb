# frozen_string_literal: true

# rubocop:disable Style/MixinUsage
include ActionDispatch::TestProcess
# rubocop:enable Style/MixinUsage

FactoryBot.define do
  factory :essay_submission_grade do
    grade 120.0
  end
end
