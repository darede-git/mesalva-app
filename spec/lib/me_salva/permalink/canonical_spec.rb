# frozen_string_literal: true

require 'spec_helper'
require 'me_salva/permalinks/canonical'

RSpec.shared_examples 'a canonical update with error message' do
  it 'should save the correct log dispite the error' do
    described_class.new('test').update_from_csv
    expect(file_writer).to have_received(:write).with(log_file_name, log).once
  end
end

describe MeSalva::Permalinks::Canonical do
  let(:csv_content) do
    [
      %w[slug canonical_uri],
      ['node/node_module', 'another_node/another_node_module']
    ]
  end
  let(:file_writer) { MeSalva::Aws::File }
  let(:log_file_name) { "test_log_#{Time.now}.txt" }
  let!(:permalink) do
    create(:permalink, slug: 'node/node_module', canonical_uri: nil)
  end
  let!(:canonical_permalink) do
    create(:permalink, slug: 'another_node/another_node_module')
  end

  describe '#update_from_csv' do
    let(:log) do
      "Permalink com slug #{permalink.slug} canonizado com sucesso."
    end

    before do
      Timecop.freeze(Time.now)
      allow(MeSalva::Aws::Csv).to receive(:read).with('test')
                                                .and_return(csv_content)
      allow(file_writer).to receive(:write).and_return(true)
    end
    context 'the canonical uri exists' do
      let!(:canonical_uri) do
        create(:canonical_uri, slug: canonical_permalink.slug)
      end
      context 'permalink being canonized exists' do
        it 'updates the canonical_uri of permalink with the given slug' do
          described_class.new('test').update_from_csv
          expect(permalink.reload.canonical_uri).to eq(canonical_permalink.slug)
          expect(file_writer).to have_received(:write).with(log_file_name, log)
                                                      .once
        end
      end

      context 'a permalink on the list does not exist' do
        let(:log) do
          "O Permalink com o slug non-existent não existe."
        end
        let(:csv_content) do
          [
            %w[slug canonical_uri],
            %w[non-existent anything]
          ]
        end
        it_should_behave_like 'a canonical update with error message'
      end
    end

    context 'the canonical uri does not exist' do
      let(:log) do
        "Erro na canonização do permalink com slug node/node_module. " \
        "Erros: {:permalink=>[\"Canonical com slug node/node_module não " \
        "encontrado.\"]}"
      end
      it_should_behave_like 'a canonical update with error message'
    end
  end
end
