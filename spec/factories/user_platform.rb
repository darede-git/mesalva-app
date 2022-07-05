# frozen_string_literal: true

FactoryBot.define do
  factory :user_platform do
    association :user, factory: :user
    association :platform_unity, factory: :platform_unity

    platform_id { platform_unity.platform.id }
    role 'student'
    verified true
    factory :admin_user_platform do
      role 'admin'
    end
  end
end
