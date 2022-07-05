# frozen_string_literal: true

require 'spec_helper'

describe MeSalva::Aws::Unzip do
  let(:medium) { create(:medium_book) }
  let(:clear_directory) { clear_directory }

  describe 'unzip medium' do
    context 'has no unziped folder' do
      before { clear_directory }
      it 'unzips succefully' do
        described_class.new.unzip_medium(medium.slug)
        expect(File.exist?(medium.attachment.url.gsub('.zip', '/index.html'))).to eq(true)
        clear_directory
      end
    end
  end

  def clear_directory
    return unless Dir.exist?(medium.attachment.url.gsub('.zip', ''))

    FileUtils.rm_r(medium.attachment.url.gsub('.zip', ''))
  end
end
