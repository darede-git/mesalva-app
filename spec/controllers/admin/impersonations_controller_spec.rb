# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ImpersonationsController, type: :controller do
  let!(:user) { create(:user, email: 'student@mesalva.com') }
  let!(:teacher) { create(:teacher, email: 'teacher@mesalva.com') }
  let!(:admin) { create(:admin, email: 'admin@mesalva.com') }
  let(:error_response) { { 'errors' => [t('errors.messages.not_found')] } }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:admin]
  end

  describe 'POST #create' do
    context 'as an admin' do
      before { authentication_headers_for(admin) }

      context 'passing a valid uid' do
        context 'impersonating a user' do
          it 'returns a valid header for impersonation' do
            post :create, params: { uid: 'student@mesalva.com' }

            assert_resource_impersonation(user, %i[education_level
                                                   objective])
          end
        end
      end

      context 'passing an invalid uid' do
        it 'returns a valid header for impersonation' do
          post :create, params: { uid: 'invalid@mesalva.com' }

          expect(response).to have_http_status(:not_found)
          expect(response.headers.keys).to include_authorization_keys
          expect(response.headers['uid']).to eq(admin.email)
          expect(parsed_response).to eq(error_response)
        end
      end
    end

    describe 'as an user' do
      it 'returns unauthorized status' do
        post :create, params: { uid: 'user@email.com' }

        expect(response).to have_http_status(:unauthorized)
        expect(response.headers.keys).not_to include_authorization_keys
      end
    end
  end

  def assert_resource_impersonation(resource, includes = [])
    serializer = serializer_for(resource)
    assert_jsonapi_response(:ok, resource, serializer, includes)
  end

  def serializer_for(resource)
    "#{resource.model_name.name.classify}Serializer".constantize
  end
end
