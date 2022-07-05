# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::MediumRatingsController, type: :controller do
  include PermissionHelper

  let(:default_serializer) { MediumRatingsSerializer }

  context '#show' do
    context 'as user' do
      before { user_session }
      context 'with permission' do
        context 'with a valid medium_rating' do
          let!(:medium_rating) { create(:medium_rating, user: user) }
          it 'returns medium_rating' do
            get :show, params: { medium_slug: medium_rating.medium.slug }

            expect(response).to have_http_status(:ok)
            expect(parsed_response['data']['attributes']['value']).to eq(medium_rating.value)
          end
        end
      end
    end
  end

  context '#create' do
    context 'as user' do
      before { user_session }
      context 'with permission' do
        context 'with valid params' do
          let!(:medium) { create(:medium) }
          it 'creates a medium_rating' do
            post :create, params: { value: 4, medium_slug: medium.slug }
            change(MediumRating, :count).by(1)

            assert_apiv2_response(:created,
                                  MediumRating.last,
                                  MediumRatingsSerializer)
          end
        end
      end
    end
  end
end
