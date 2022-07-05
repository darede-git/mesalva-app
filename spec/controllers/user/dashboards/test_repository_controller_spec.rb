# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::Dashboards::TestRepositoryController, type: :controller do
  describe.skip 'GET #index' do
    let(:result) do
      { 'results' => { 'exercise' => { 'total_correct_count' => 0,
                                       'total_count' => 0,
                                       'total_wrong_count' => 0,
                                       'week_correct_count' => 0,
                                       'week_count' => 0,
                                       'week_wrong_count' => 0 } } }
    end
    context 'with a valid session' do
      before do
        user_session
      end

      it 'returns the user general and last 7 days stats' do
        get :index

        assert_type_and_status(:ok)
        expect(parsed_response).to eq(result)
      end
    end

    context 'without a valid session' do
      it 'returns unauthorized status' do
        get :index

        assert_type_and_status(:unauthorized)
      end
    end
  end

  describe.skip 'GET #show' do
    context 'with a valid session' do
      before do
        user_session
      end

      context 'when an exercise with the submission_token exists' do
        let!(:item) { create(:item) }
        let!(:medium) do
          create(:medium_fixation_exercise,
                 :valid_answers_attributes,
                 items: [item])
        end
        let!(:medium2) do
          create(:medium_fixation_exercise,
                 name: 'no answer',
                 items: [item])
        end
        let(:result) do
          { 'results' =>
            { 'total-count' => 1,
              'exercises' => [
                { 'order' => 1,
                  'medium-name' => medium.name,
                  'medium-text' => medium.medium_text,
                  'correction' => 'sample correction',
                  'correct-answer-id' => medium.correct_answer_id,
                  'slug' => 'sim01ling01t',
                  'correct' => false,
                  'answer-id' => 245_091 },
                { 'order' => 2,
                  'medium-name' => 'no answer',
                  'medium-text' => medium2.medium_text,
                  'correction' => 'sample correction',
                  'correct-answer-id' => medium2.correct_answer_id,
                  'slug' => nil,
                  'correct' => nil,
                  'answer-id' => nil }
              ] } }
        end

        before do
          allow(PermalinkEvent.__elasticsearch__).to receive(:search)
            .and_return(raw_prep_test_answers_double(item.id, medium.id))
        end

        # it 'returns the user detailed consumption' do
        #   skip "uses elastic"
        #   get :show, params: { submission_token: 'submission_token' }

        #   assert_type_and_status(:ok)
        #   expect(parsed_response).to eq(result)
        # end
      end
    end

    context 'without a valid session' do
      it 'returns unauthorized status' do
        get :show, params: { submission_token: 'submission_token' }

        assert_type_and_status(:unauthorized)
      end
    end
  end
end
