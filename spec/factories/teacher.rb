# frozen_string_literal: true

FactoryBot.define do
  factory :teacher do
    sequence :uid, &:to_s
    name 'Teacher Me Salva!'
    active true
    image Rack::Test::UploadedFile.new(File.join(Rails.root,
                                                 'spec',
                                                 'support',
                                                 'uploaders',
                                                 'mesalva.jpeg'))
    sequence :email do |n|
      "teacher#{n}@mesalva.com"
    end
    description 'This is an teacher!'
  end
end
