# frozen_string_literal: true

FactoryBot.define do
  factory :item_medium do
    item { create(:item) }
    medium { create(:medium) }
  end
end
