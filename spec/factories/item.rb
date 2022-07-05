# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    sequence :name do |n|
      "item#{n}"
    end
    active true
    sequence(:token) do |n|
      "some-token-#{n}"
    end
    downloadable true
    item_type 'video'
    free false
    trait :inactive do
      active false
    end
    trait :scheduled_streaming do
      item_type 'streaming'
      streaming_status 'scheduled'
      sequence(:chat_token) do |n|
        "some-token-#{n}"
      end
      free true
      starts_at Date.today + 14.hours
      ends_at Date.today + 16.hours
    end
    trait :recorded_streaming do
      item_type 'streaming'
      streaming_status 'recorded'
      chat_token 'IKX20cmIFm'
      free true
      starts_at Time.now
      ends_at Time.now + 2.hours
    end
    trait :essay_video do
      item_type 'essay_video'
      free false
    end
    trait :correction_video do
      item_type 'correction_video'
      free false
    end
    trait :public_document do
      item_type 'public_document'
      description 'description of document'
      created_by 'criador@mesalva.com'

      public_document_info_attributes do
        { document_type: "summary",
          teacher: "Me Salva!",
          course: "ENG03092 - Mecânica dos Sólidos I - A" }
      end
    end
  end
end
