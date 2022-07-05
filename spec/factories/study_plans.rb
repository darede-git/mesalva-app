# frozen_string_literal: true

FactoryBot.define do
  factory :study_plan do
    association :user, factory: :user
    start_date "2017-09-28 10:53:54 -0200"
    end_date "2017-10-28 10:53:54 -0200"
    shifts [{ 0 => :mid }]
    available_time 12
    subject_ids [1]
    offset 0
    limit 7
    trait :with_dinamic_dates do
      created_at Time.now - 3.day
      start_date Time.now - 3.day
      updated_at Time.now - 3.day
      end_date Time.now + 3.month
    end
    trait :not_started do
      created_at Time.now - 3.day
      start_date Time.now + 1.day
      end_date Time.now + 3.month
    end
  end
end
