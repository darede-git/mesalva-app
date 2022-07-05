# frozen_string_literal: true

FactoryBot.define do
  factory :content_teacher_item do
    association :content_teacher, factory: :content_teacher
  end
end
