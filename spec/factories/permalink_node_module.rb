# frozen_string_literal: true

FactoryBot.define do
  factory :permalink_node_module do
    association :node_module, factory: :node_module
    association :permalink, factory: :permalink
  end
end
