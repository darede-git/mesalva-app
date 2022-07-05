# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResetPasswordsController, type: :controller do
  context 'user is admin' do
    before { admin_session }
    context 'user being searched exists' do
      let!(:user) { create(:user) }
      it 'returns the token to reset the user' do
        get :reset, params: { user_uid: user.uid }
        expect(parsed_response['data']['attributes']['token']).not_to be_nil
      end

      it 'response has status ok' do
        expect(response).to have_http_status(:ok)
      end
    end
    context 'user being searched does not exists' do
      it 'response has status unprocessable entity' do
        get :reset, params: { user_uid: 'a@a.com' }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
