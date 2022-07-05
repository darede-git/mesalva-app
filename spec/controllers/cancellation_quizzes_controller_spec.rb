# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CancellationQuizzesController, type: :controller do
  let!(:user) { create(:user) }
  let!(:order) { create(:order_valid) }
  let(:valid_attributes) do
    FactoryBot.attributes_for(:cancellation_quiz)
              .merge(order_id: order.token)
  end

  let(:invalid_attributes) do
    FactoryBot.attributes_for(:cancellation_quiz, order_id: nil)
  end

  let(:nps) do
    { net_promoter_score_attributes: { score: '9',
                                       reason: 'Amo o Me Salva!' } }
  end

  let(:nps_response) do
    [{ 'id' => NetPromoterScore.last.id.to_s, 'type' => 'net-promoter-scores',
       'attributes' => { 'score' => 9, 'reason' => 'Amo o Me Salva!' } }]
  end

  before do
    authentication_headers_for(user)
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new cancellation quiz' do
        mock_intercom_update_user
        expect(UpdateIntercomUserWorker).to receive(:perform_async)
        expect do
          post :create, params: valid_attributes.merge(nps)
        end.to change(CancellationQuiz, :count)
          .by(1).and change(NetPromoterScore, :count).by(1)

        last_cancellation_quiz = CancellationQuiz.last

        expect(parsed_response['included']).to eq(nps_response)

        assert_jsonapi_response(:created,
                                last_cancellation_quiz,
                                CancellationQuizSerializer,
                                [:net_promoter_score])
      end
    end

    context 'with invalid params' do
      it 'returns http unprocessable_entity' do
        expect do
          post :create, params: invalid_attributes.merge(nps)
        end.to change(CancellationQuiz, :count)
          .by(0).and change(NetPromoterScore, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
