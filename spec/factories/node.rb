# frozen_string_literal: true

FactoryBot.define do
  factory :node do
    sequence :name do |n|
      "node#{n}"
    end
    active true
    node_type 'education_segment'
    sequence(:token) do |n|
      "some-token-#{n}"
    end
    sequence :position
    factory :node_area do
      node_type 'area'
      color_hex 'FFFFFF'
    end
    factory :node_library do
      node_type 'library'
    end
    factory :node_subject do
      node_type 'subject'
      color_hex 'FFFFFF'
      trait :inactive do
        active false
      end
    end
    factory :node_year do
      node_type 'year'
      color_hex 'FFFFFF'
    end
    factory :node_area_subject do
      node_type 'area_subject'
    end
    factory :node_nil_position do
      position nil
    end
    trait :inactive do
      active false
    end
  end
end
