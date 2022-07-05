# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Permalink::CanonicalController, type: :controller do
  let!(:permalink) { create(:permalink) }
  let(:valid_attributes) do
    { canonical_uri: permalink_to_canonize.slug,
      slug: permalink.slug }
  end
  let!(:permalink_to_canonize) { create(:permalink) }
  let!(:canonical_uri) do
    create(:canonical_uri, slug: permalink_to_canonize.slug)
  end

  describe 'PUT #update' do
    context 'as admin' do
      before { admin_session }
      context 'with valid params' do
        it 'updates the permalink' do
          put :update, params: valid_attributes

          assert_jsonapi_response(:ok,
                                  permalink.reload,
                                  Permalink::PermalinkSerializer)
        end
      end
      context 'with a non existing permalink' do
        it 'renders not found' do
          valid_attributes[:slug] = 'unexisting-slug'

          put :update, params: valid_attributes

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'as user' do
      before { user_session }
      context 'with valid params' do
        it 'returns http unauthorized' do
          put :update, params: valid_attributes

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
