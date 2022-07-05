# frozen_string_literal: true

RSpec.shared_examples 'valid uploader' do |files|
  files.each do |file|
    it 'uploads the file' do
      ext = file.split('.').last
      File.open(file) { |f| uploader.store!(f) }
      expect(uploader.file.file).to include("integration.#{ext}")
    end
  end
end
RSpec.shared_examples 'invalid uploader' do |files|
  files.each do |file|
    it 'should raise an error message' do
      ext = "\"#{file.split('.').last}\""
      allowed_types = uploader.extension_whitelist.join(', ')

      expect do
        File.open(file) { |f| uploader.store!(f) }
      end.to raise_error(CarrierWave::IntegrityError,
                         t('errors.messages.extension_whitelist_error',
                           extension: ext,
                           allowed_types: allowed_types))
    end
  end
end
