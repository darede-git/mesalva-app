# frozen_string_literal: true

require 'spec_helper'

describe MeSalva::Aws::Csv do
  let(:csv_content) do
    File.read('spec/fixtures/aws/file.csv')
  end

  let(:parsed_csv) do
    [
      %w[slug canonical_uri],
      ["node/node_module", "another_node/another_node_module"],
      %w[permalink another_permalink]
    ]
  end

  describe 'read' do
    context 'file exists' do
      before do
        allow(described_class).to receive(:open_file)
          .with('test').and_return(csv_content)
      end
      it 'opens and parses the file' do
        expect(described_class.read('test')).to eq(parsed_csv)
      end
    end
  end
end
