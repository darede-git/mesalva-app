# frozen_string_literal: true

require 'rails_helper'
require 'carrierwave/test/matchers'

describe ImageUploader do
  include CarrierWave::Test::Matchers

  let(:model) { double(id: 1) }
  let(:uploader) { ImageUploader.new(model) }

  context 'valid extension' do
    it_should_behave_like 'valid uploader',
                          %w[spec/support/uploaders/mesalva.png
                             spec/support/uploaders/mesalva.jpg
                             spec/support/uploaders/mesalva.gif]
  end

  context 'invalid extension' do
    it_should_behave_like 'invalid uploader',
                          ['spec/support/uploaders/mesalva.pdf']
  end
end
