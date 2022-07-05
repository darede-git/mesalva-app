# frozen_string_literal: true

FactoryBot.define do
  factory :admin do
    sequence :uid, &:to_s
    sequence :name do |n|
      "Admin #{n} Me Salva!"
    end
    sequence :email do |n|
      "admin#{n}@mesalva.com"
    end
    description 'This is an admin!'
    active true
    role 'dev'
    image Rack::Test::UploadedFile.new(File.join(Rails.root,
                                                 'spec',
                                                 'support',
                                                 'uploaders',
                                                 'mesalva.jpeg'))
  end
end
