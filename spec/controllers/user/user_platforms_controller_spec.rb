# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::UserPlatformsController, type: :controller do
  describe 'GET #me' do
    before { user_platform_session }
    context 'with user session' do
      it 'returns the user platform' do
        get :me
        expect(parsed_response).not_to be_nil
      end
    end
  end

  describe 'GET #me' do
    context 'without any user' do
      it 'returns not found status' do
        get :me
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #me' do
    before { user_platform_session }
    context 'with user session' do
      it 'checks if only two fields have returned and wheter the fields are options and unity' do
        get :me, params: { platform_slug: user_platform.platform.slug }
        expect(parsed_response['data']['attributes'].key?('options')).to eq(true)
        expect(parsed_response['data']['attributes'].key?('platform-unity-id')).to eq(true)
      end
    end
  end
end
