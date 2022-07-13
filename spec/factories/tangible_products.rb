# frozen_string_literal: true

FactoryBot.define do
  factory :tangible_product do
    sequence :name do |n|
      "Product Name #{n}"
    end

    description 'Some description'

    sequence :sku do |n|
      "some_unique_sku_#{n}"
    end

    image Rack::Test::UploadedFile.new(File.join(Rails.root,
                                                 'spec',
                                                 'support',
                                                 'uploaders',
                                                 'mesalva.jpeg'))
  end
  trait :with_correios_attributes do
    sequence :name do |n|
      "Product Name #{n}"
    end
    description 'Some description'
    weight 0.8
    length 20
    height 20
    width 10
    sequence :sku do |n|
      "some_unique_sku_#{n}"
    end
    image Rack::Test::UploadedFile.new(File.join(Rails.root,
                                                 'spec',
                                                 'support',
                                                 'uploaders',
                                                 'mesalva.jpeg'))
  end
end
