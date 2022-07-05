# frozen_string_literal: true

require 'rails_helper'
require 'carrierwave/test/matchers'

describe AttachmentUploader do
  include CarrierWave::Test::Matchers

  let(:platform) { create(:platform) }
  let(:model) { create(:medium_book, platform_id: platform.id) }
  let(:uploader) { AttachmentUploader.new(model) }

  context 'valid extension' do
    context 'pdf' do
      it_should_behave_like 'valid uploader',
                            ['spec/support/uploaders/mesalva.pdf']
    end

    context 'zip' do
      it_should_behave_like 'valid uploader',
                            ['spec/support/uploaders/debug-pageflip.zip']
    end
  end

  context 'invalid extension' do
    it_should_behave_like 'invalid uploader',
                          ['spec/support/uploaders/mesalva.csv']
  end
end
