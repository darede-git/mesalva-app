# frozen_string_literal: true

require 'spec_helper'
require 'me_salva/event/permalink/prep_test_answers'

describe MeSalva::Event::Permalink::PrepTestAnswers do
  describe.skip 'results' do
    let!(:prep_test_score) { create(:prep_test_score) }
    let(:subject) do
      MeSalva::Event::Permalink::PrepTestAnswers.new(
        user_id: 1,
        submission_token: prep_test_score.submission_token
      )
    end

    let!(:permalink_event) do
      create(:permalink_event_document_prep_test,
             user_id: 1,
             submission_token: prep_test_score.submission_token)
    end
    it 'returns the prep test answers for given submission token' do
      expect(subject.results.first['_id']).to eq(permalink_event['_id'])
    end
  end

  describe.skip 'score' do
    context 'with submission_token on prep test score' do
      let(:subject) do
        MeSalva::Event::Permalink::PrepTestAnswers.new(
          user_id: 1,
          submission_token: prep_test_score.submission_token
        )
      end
      let!(:prep_test_score) { create(:prep_test_score) }
      it 'returns score of prep test score' do
        expect(subject.score).to eq(prep_test_score.score)
      end
    end
  end
end
