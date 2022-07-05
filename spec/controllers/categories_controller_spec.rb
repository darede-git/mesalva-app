# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  describe 'GET #index' do
    context 'as an Admin' do
      it 'returns the categories' do
        mock_samba_videos(categories: SambaVideos::Category)
        authentication_headers_for(admin)
        get :index

        assert_type_and_status(:success)
      end
    end

    context 'as an User' do
      it 'returns http status unauthorized' do
        authentication_headers_for(user)
        get :index

        expect(response).to have_http_status(:unauthorized)
        assert_type_and_status(:unauthorized)
      end
    end
  end

  describe 'GET #show' do
    context 'as an Admin' do
      it 'returns the medias' do
        mock_samba_videos(medias: SambaVideos::Media)
        authentication_headers_for(admin)
        get :show, params: { id: 1 }

        assert_type_and_status(:success)
      end
    end

    context 'as an User' do
      it 'returns the medias' do
        authentication_headers_for(user)
        get :show, params: { id: 1 }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  def mock_samba_videos(**verb)
    stub_const('MeSalva::Videos', double(verb))
    allow(MeSalva::Videos).to receive(:new)
      .and_return(MeSalva::Videos)
  end
end
