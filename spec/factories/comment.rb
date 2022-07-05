# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    sequence(:text) { |n| "comofaz?#{n}" }
    association :commentable, factory: :user
  end
end
