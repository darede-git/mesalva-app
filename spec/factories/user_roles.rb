# frozen_string_literal: true

FactoryBot.define do
  factory :user_role do
    association :user, factory: :user
    association :role, factory: :role
  end

  factory :user_role_validation, class: UserRole do
    association :role, factory: :role
    association :user, factory: :user
    association :user_platform, factory: :user_platform
  end
end
