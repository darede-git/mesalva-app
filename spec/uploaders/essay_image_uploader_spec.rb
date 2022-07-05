# frozen_string_literal: true

require 'rails_helper'
require 'carrierwave/test/matchers'

describe EssayImageUploader do
  include CarrierWave::Test::Matchers

  let(:user) { double(uid: '') }
  let(:uploader) { EssayImageUploader.new(double(user: user)) }

  context 'valid extension' do
    it_should_behave_like 'valid uploader',
                          ['spec/support/uploaders/mesalva.png']
    it_should_behave_like 'valid uploader',
                          ['spec/support/uploaders/mesalva.jpeg']
  end

  context 'invalid extension' do
    it_should_behave_like 'invalid uploader',
                          ['spec/support/uploaders/mesalva.pdf']
  end
end
