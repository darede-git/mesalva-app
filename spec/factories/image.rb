# frozen_string_literal: true

# rubocop:disable Style/MixinUsage
include ActionDispatch::TestProcess
# rubocop:enable Style/MixinUsage

FactoryBot.define do
  factory :image do
    association :platform, factory: :platform
    image Rack::Test::UploadedFile.new(File.join(Rails.root,
                                                 'spec',
                                                 'support',
                                                 'uploaders',
                                                 'mesalva.png'))
  end
end
