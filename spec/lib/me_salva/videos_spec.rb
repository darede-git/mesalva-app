# frozen_string_literal: true

require 'me_salva/videos'

describe MeSalva::Videos do
  let(:limit) { 10 }
  let(:offset) { 0 }

  before do
    allow(subject).to receive(:access_token).and_return('123')
    allow(subject).to receive(:project_id).and_return('1')
  end

  subject { described_class.new(offset, limit) }

  describe '#categories' do
    it 'returns all the categories' do
      stub_const('SambaVideos::Category', double)
      allow(SambaVideos::Category).to receive(:find) { [SambaVideos::Category] }

      expect(subject.categories).to eq([SambaVideos::Category])
    end
  end

  describe '#media' do
    it 'returns all the medias' do
      stub_const('SambaVideos::Media', double)
      allow(SambaVideos::Media).to receive(:find) { [SambaVideos::Media] }

      expect(subject.medias('1')).to eq([SambaVideos::Media])
    end
  end
end
