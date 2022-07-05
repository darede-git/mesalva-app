# frozen_string_literal: true

FactoryBot.define do
  factory :permalink_node do
    association :node, factory: :node
    association :permalink, factory: :permalink
  end
end
