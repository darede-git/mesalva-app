# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ObjectivesController, type: :controller do
  let!(:objective) { create(:objective) }
  let!(:inactive) { create(:objective, :inactive) }

  describe 'GET #index' do
    it 'returns http unauthorized' do
      get :index

      expect(response.headers.keys).not_to include_authorization_keys
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns only the active objectives' do
      authentication_headers_for(user)
      get :index

      assert_jsonapi_response(:success, [objective], ObjectiveSerializer)
    end
  end

  describe 'PUT #update' do
    context 'as admin' do
      before { authentication_headers_for(admin) }

      it 'with valid params updates the requested objective' do
        put :update, params: { id: objective,
                               education_segment_slug: 'enem',
                               name: 'Estudar para o ENEM e Vestibulares' }

        assert_type_and_status(:success)
      end

      it 'with invalid params returns http unprocessable entity' do
        put :update, params: { id: objective,
                               education_segment_slug: 'enem',
                               name: '' }

        assert_type_and_status(:unprocessable_entity)
      end
    end

    it 'as user with valid params returns http unauthorized' do
      authentication_headers_for(user)
      put :update, params: { id: objective,
                             education_segment_slug: 'enem',
                             name: 'Estudar para o ENEM e Vestibulares' }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'DELETE #destroy' do
    it 'as admin destroys the requested objective' do
      authentication_headers_for(admin)
      expect do
        delete :destroy, params: { id: objective }
      end.to change(Objective, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it 'as user returns http unauthorized' do
      authentication_headers_for(user)
      delete :destroy, params: { id: objective }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
