# frozen_string_literal: true

require 'spec_helper'

describe MeSalva::Aws::File do
  let(:csv_content) do
    File.read('spec/fixtures/aws/file.csv')
  end

  let(:request_uri) do
    "https://s3.amazonaws.com/#{ENV['S3_BUCKET']}/uploads/csv/test.csv"
  end

  describe '.read' do
    context 'file exists' do
      before do
        allow(described_class).to receive(:open_file)
          .with(request_uri).and_return(csv_content)
      end
      it 'opens the file' do
        expect(described_class.read('test.csv')).to eq(csv_content)
        expect(described_class).to have_received(:open_file)
          .with(request_uri).once
      end
    end
  end
end
