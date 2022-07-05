# frozen_string_literal: true

require 'spec_helper'

describe MeSalva::Aws::Log do
  let(:log_content) do
    [
      'First line',
      'Second line',
      'Third line'
    ]
  end
  let(:log_file_content) do
    "First line\nSecond line\nThird line"
  end
  let(:file_name) { "test_log_#{Time.now}.txt" }
  describe '#save' do
    before do
      Timecop.freeze(Time.now)
      allow(MeSalva::Aws::File).to receive(:write).and_return true
    end
    it 'should write a text file with the formatted content' do
      logger = described_class.new('test')
      log_content.each do |line|
        logger.append(line)
      end
      logger.save

      expect(MeSalva::Aws::File).to have_received(:write)
        .with(file_name, log_file_content).once
    end
  end
end
