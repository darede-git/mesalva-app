# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  let(:package) { create(:package_valid_with_price) }
  let(:access) { create(:access_with_duration_and_node) }
  let(:platform) { create(:platform, name: 'Enem') }
  describe '#Show' do
    context 'with data' do
      context 'as simple user(without even be logged in)' do
        before { { access: access, package: package, paltform: platform } }
        it 'returns ok and only accessible entitys' do
          get :show, params: { data: 'Enem' }
          expect(response).to have_http_status(:ok)
          expect(parsed_response.map { |obj| obj['content']['entity'] })
            .to match_array(%w[package package])
        end
      end
    end
  end

  describe '#filtered_search' do
    context 'with all valid params' do
      context 'as admin' do
        before { { access: access, package: package, paltform: platform } }
        before { admin_session }
        it 'returns ok and filtered data' do
          post :filtered_search, params: { data: 'Enem', page: 1,
                                           entity: 'platform', limiter: 10 }
          expect(response).to have_http_status(:ok)
          expect(parsed_response.map { |obj| obj['content']['entity'] })
            .to match_array(%w[platform])
        end
      end
      context 'as simple user(without even be logged in)' do
        it 'returns unauthorized' do
          post :filtered_search, params: { data: 'any' }
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
