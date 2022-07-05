# frozen_string_literal: true

require 'rails_helper'
require 'carrierwave/test/matchers'

describe MemberImageUploader do
  include CarrierWave::Test::Matchers

  let(:user) { double(uid: '') }
  let(:uploader) { MemberImageUploader.new(user) }

  before do
    MemberImageUploader.enable_processing = true
  end

  after do
    MemberImageUploader.enable_processing = false
    uploader.remove!
  end

  context 'valid extension' do
    it 'scales down an image to be exactly 260 by 260 pixels' do
      File.open('spec/support/uploaders/mesalva.jpeg') do |f|
        uploader.store!(f)
      end
      image = MiniMagick::Image.open(uploader.file.file)

      expect(uploader.file.file).to include('integration.jpeg')
      expect(image[:width]).to eq(260)
      expect(image[:height]).to eq(260)
    end
  end

  context 'invalid extension' do
    it_should_behave_like 'invalid uploader',
                          ['spec/support/uploaders/mesalva.pdf']
  end
end
