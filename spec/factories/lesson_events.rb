# frozen_string_literal: true

FactoryBot.define do
  factory :lesson_event do
    association :user, factory: :user
    node_module_slug { "module-slug" }
    item_slug { "item-slug" }
    submission_token { "token" }
  end
end
