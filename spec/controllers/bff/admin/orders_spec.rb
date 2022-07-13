# frozen_string_literal: true

RSpec.describe Bff::Admin::Orders, type: :controller do
  include PermissionHelper
  describe 'GET #weekly_essay' do
    before { user_session }
    before { grant_test_permission('update_price_paid') }
    context 'with a user' do
      let!(:usuario) { create(:user) }
      context 'with a order for asaas broker' do
        let!(:ordem) { create(:order, user_id: usuario.id, broker: 'asaas') }
        context 'making the call to update Order method' do
          context 'for a new price paid' do
            let!(:new_price_paid) { 2000 }
            it 'update_price_paid', :vcr do
              put :update_price_paid, params: { token: ordem.token, new_price_paid: new_price_paid }
              expect(response).to have_http_status(:ok)
              expect(ordem.reload).to have_attributes(price_paid: new_price_paid)
            end
          end
        end
      end
      context 'with a order for asaas broker' do
        let!(:ordem) { create(:order, user_id: usuario.id) }
        context 'making the call to update the Order method without broker asaas' do
          context 'for a new price paid' do
            let!(:new_price_paid) { 2000 }
            it 'update_price_paid', :vcr do
              put :update_price_paid, params: { token: ordem.token, new_price_paid: new_price_paid }
              expect(response).to have_http_status(:not_found)
            end
          end
        end
      end
    end
  end
end
