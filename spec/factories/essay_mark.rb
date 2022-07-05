# frozen_string_literal: true

FactoryBot.define do
  factory :essay_mark do
    association :essay_submission, factory: :essay_submission
    description 'descrição da marcação'
    mark_type 'ortografia'
    coordinate do
      {
        "x" => "1",
        "y" => "1"
      }
    end
  end
end
