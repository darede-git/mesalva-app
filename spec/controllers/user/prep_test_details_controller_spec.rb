# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::PrepTestDetailsController, type: :controller do
  let(:default_serializer) { V2::PrepTestDetailSerializer }
  describe '#index' do
    before { user_session }
    let(:userPrepTestDetail) do
      create(:prep_test_detail)
    end
    context 'with a valid token' do
      it 'returns one record' do
        get :index, params: { token: userPrepTestDetail.token }

        assert_apiv2_response(:ok, [userPrepTestDetail], default_serializer)
      end
    end
    context 'with a invalid token' do
      it 'does not return any record' do
        get :index, params: { token: "invalid-token" }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
