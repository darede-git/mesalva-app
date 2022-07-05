# frozen_string_literal: true

require 'rails_helper'

describe MeSalva::Canonical do
  let(:csv_content) do
    [
      ["slug"],
      ["node/node_module"],
      ["node/node_module2"]
    ]
  end
  let(:file_reader) { MeSalva::Aws::Csv }
  let(:file_writer) { MeSalva::Aws::File }

  let!(:permalink) do
    create(:permalink, slug: 'node/node_module')
  end
  let!(:another_permalink) do
    create(:permalink, slug: 'node/node_module2')
  end
  let(:success_log) do
    "Sucesso na criação do canonical com slug 'node/node_module'\n" \
    "Sucesso na criação do canonical com slug 'node/node_module2'"
  end
  let(:log_with_error) do
    "Sucesso na criação do canonical com slug 'node/node_module'\nErro na "\
    "criação do canonical com slug \"I do not exist\". Erro(s): {:permalink=>" \
    "[\"O Permalink com o slug I do not exist não existe.\"]}\nSucesso na "\
    "criação do canonical com slug 'node/node_module2'"
  end
  let(:log_file_name) do
    "test_log_#{Time.now}.txt"
  end

  describe '.insert_from_csv' do
    before do
      allow(file_writer).to receive(:write).and_return(true)
      Timecop.freeze(Time.now)
    end
    context 'the first row has a valid attribute' do
      context 'all permalinks listed exists' do
        before do
          allow(file_reader).to receive(:read).with('test')
                                              .and_return(csv_content)
        end
        it 'should create a new canonical' do
          expect { described_class.new('test').insert_from_csv }
            .to change(CanonicalUri, :count).by(2)
          expect(CanonicalUri.pluck(:slug).last(2))
            .to include(permalink.slug, another_permalink.slug)
          expect(file_writer).to have_received(:write)
            .with(log_file_name, success_log).once
        end
      end

      context 'one permalink listed does not exist' do
        let(:csv_content_with_error) do
          csv_content.insert(2, ["I do not exist"])
        end
        before do
          allow(file_reader).to receive(:read)
            .with('test').and_return(csv_content_with_error)
        end
        it 'should not stop the insertion' do
          expect { described_class.new('test').insert_from_csv }
            .to change(CanonicalUri, :count).by(2)
          expect(CanonicalUri.pluck(:slug).last(2))
            .to include(permalink.slug, another_permalink.slug)
          expect(file_writer).to have_received(:write)
            .with(log_file_name, log_with_error).once
        end
      end
    end

    context 'the first line makes reference to a invalid attribute' do
      let(:csv_content) do
        [
          ["wrong-attribute"],
          ["node/node_module"],
          ["node/node_module2"]
        ]
      end
      before do
        allow(file_reader).to receive(:read).with('test')
                                            .and_return(csv_content)
      end
      it 'should raise error' do
        expect { described_class.new('test').insert_from_csv }
          .to raise_error MeSalva::Error::NonexistentColumnError
      end
    end
  end
end
