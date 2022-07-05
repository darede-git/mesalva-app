# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrepTestsController, type: :controller do
  before { user_session }
  context 'valid params' do
    let!(:prep_test) { create(:prep_test) }
    it 'renders the prep test' do
      get :show, params: { permalink_slug: prep_test.permalink_slug }

      expect(response).to have_http_status(:ok)
      expect(parsed_response['data']['attributes']).not_to be_empty
    end
  end
  context 'invalid params' do
    it 'renders not found' do
      get :show, params: { permalink_slug: 1 }

      expect(response).to have_http_status(:not_found)
    end
  end
end
