# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EducationLevelsController, type: :controller do
  let!(:education_level) { create(:education_level) }

  describe 'GET #index' do
    it 'returns http success' do
      authentication_headers_for(user)
      get :index

      assert_jsonapi_response(:success,
                              [education_level],
                              EducationLevelSerializer)
    end
  end

  describe 'PUT #update' do
    context 'as admin' do
      context 'with valid params' do
        it 'updates the requested education_level' do
          authentication_headers_for(admin)
          put :update, params: { id: education_level,
                                 name: 'Ensino Médio concluído' }

          assert_type_and_status(:success)
        end
      end

      context 'with invalid params' do
        it 'returns http unprocessable entity' do
          authentication_headers_for(admin)

          put :update, params: { id: education_level, name: '' }

          assert_type_and_status(:unprocessable_entity)
        end
      end
    end

    context 'as user' do
      context 'with valid params' do
        it 'returns http unauthorized' do
          authentication_headers_for(user)

          put :update, params: { id: education_level,
                                 name: 'Ensino Médio concluído' }

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as admin' do
      it 'destroys the requested education_level' do
        authentication_headers_for(admin)

        expect do
          delete :destroy, params: { id: education_level }
        end.to change(EducationLevel, :count).by(-1)

        expect(response.headers.keys).not_to include_authorization_keys
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'as user' do
      it 'returns http unauthorized' do
        authentication_headers_for(user)
        delete :destroy, params: { id: education_level }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
