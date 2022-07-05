# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CorrectionStylesController, type: :controller do
  let!(:user) { create(:user) }

  let!(:correction_style) { create(:correction_style) }

  describe 'GET #index' do
    context 'as an user' do
      it 'returns all correction_styles' do
        user_session
        get :index

        assert_jsonapi_response(:ok,
                                CorrectionStyle.all.to_ary,
                                CorrectionStyleSerializer)
      end
    end

    context 'without authentication' do
      it 'returns http unauthorized' do
        get :index

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
