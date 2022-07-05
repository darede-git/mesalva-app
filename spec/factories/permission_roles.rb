# frozen_string_literal: true

FactoryBot.define do
  factory :permission_role do
    association :role, factory: :role
    association :permission, factory: :permission
  end

  factory :permission_role_validation, class: PermissionRole do
    association :role, factory: :role
    association :permission, factory: :permission
  end

  factory :permission_role_without_role, class: PermissionRole do
    association :permission, factory: :permission
  end

  factory :permission_role_without_permission, class: PermissionRole do
    association :role, factory: :role
  end
end
