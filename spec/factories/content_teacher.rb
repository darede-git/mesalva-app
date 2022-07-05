# frozen_string_literal: true

FactoryBot.define do
  factory :content_teacher do
    sequence :name do |n|
      "example teacher #{n}"
    end
    slug "examplo slug"
    image Rack::Test::UploadedFile.new(File.join(Rails.root,
                                                 'spec',
                                                 'support',
                                                 'uploaders',
                                                 'mesalva.png'))

    description "examplo description"
    content_type "examplo type"
    email nil
  end
end
