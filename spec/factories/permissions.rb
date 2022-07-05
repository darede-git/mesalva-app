# frozen_string_literal: true

FactoryBot.define do
  factory :permission do
    sequence(:context) { |n| "images-#{n}" }
    sequence(:action) { |n| "create-#{n}" }
    permission_type "route"
  end

  factory :permission_controller_blank, class: Permission do
    context ""
    action "index"
  end

  factory :permission_action_blank, class: Permission do
    context "user_platforms"
    action ""
  end
end
