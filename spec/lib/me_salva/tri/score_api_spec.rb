# frozen_string_literal: true

require 'me_salva/tri/score_api'

describe MeSalva::Tri::ScoreApi do
  include RequestHelpers
  let!(:address_argument) { "#{ENV['TRI_API_URL']}predict" }

  let!(:body_argument_language) do
    { answers: [true, false],
      blueprint: { "year": 2015,
                   "test": "linguagens",
                   "language": "esp" } }.to_json
  end

  let!(:body_argument_humanity) do
    { answers: [true, false],
      blueprint: { "year": 2015,
                   "test": "humanas" } }.to_json
  end

  let!(:header_argument) { { 'Content-Type' => 'application/json' } }

  let!(:predicted_score) { "{ \"predicted_score\": 308.95 }" }

  context 'when TRI API is down' do
    let!(:tri_reference) { create(:tri_reference) }
    before do
      allow(tri_reference).to receive(:year).and_return(2015)
      allow(tri_reference).to receive(:exam).and_return("linguagens")
      allow(tri_reference).to receive(:language).and_return("esp")

      allow(HTTParty).to receive(:post).with(
        address_argument,
        body: body_argument_language,
        headers: header_argument
      ).and_return(http_party_404_response)
    end

    it 'should avoid saving' do
      expect do
        described_class.new(answers, tri_reference.item).tri_score
      end.to raise_error(MeSalva::Error::TriApiConnectionError)
    end
  end

  context 'when TRI API is running correctly' do
    let!(:tri_reference) { create(:tri_reference, year: 2015, exam: 'humanas', language: nil) }
    before do
      allow(HTTParty).to receive(:post).with(
        address_argument,
        body: body_argument_humanity,
        headers: header_argument
      ).and_return(http_party_200_response(predicted_score))
    end

    context ', when language is not present' do
      it 'should return TRI score' do
        expect(
          described_class.new(answers, tri_reference.item).tri_score
        ).to eq 308.95
      end
    end

    context ', when language is nil' do
      before do
        allow(tri_reference).to receive(:language).and_return(nil)
      end

      it 'should return TRI score' do
        expect(
          described_class.new(answers, tri_reference.item).tri_score
        ).to eq 308.95
      end
    end
  end

  def answers
    [{ "correct" => true }, { "correct" => false }]
  end
end
