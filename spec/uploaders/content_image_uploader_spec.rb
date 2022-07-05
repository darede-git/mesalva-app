# frozen_string_literal: true

require 'rails_helper'
require 'carrierwave/test/matchers'

describe ContentImageUploader do
  include CarrierWave::Test::Matchers

  let(:model) { double(slug: '') }
  let(:uploader) { ContentImageUploader.new(model) }

  context 'valid extension' do
    it_should_behave_like 'valid uploader',
                          ['spec/support/uploaders/mesalva.png']
  end

  context 'invalid extension' do
    it_should_behave_like 'invalid uploader',
                          ['spec/support/uploaders/mesalva.pdf']
  end
end
