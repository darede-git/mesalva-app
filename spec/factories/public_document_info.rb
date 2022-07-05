# frozen_string_literal: true

FactoryBot.define do
  factory :public_document_info do
    document_type "test"
    teacher "Professor"
    course "Disciplina 1"
    association :major, factory: :major
    association :college, factory: :college
    association :item, factory: :item
  end
end
