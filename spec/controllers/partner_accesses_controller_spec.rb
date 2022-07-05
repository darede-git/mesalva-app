# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PartnerAccessesController, type: :controller do
  context '#register' do
    context 'with user' do
      before { user_session }

      let!(:partner_access) { create(:partner_access) }
      context 'valid params' do
        it 'register user and returns ok if birth date and cpf have a match' do
          put :register, params: { cpf: partner_access.cpf,
                                   birth_date: partner_access.birth_date }
          expect(response).to have_http_status(:ok)
          expect(partner_access.reload.user_id).to eq(user.id)
        end
      end

      context 'invalid params' do
        it 'returns not found' do
          put :register, params: { cpf: '123456789',
                                   birth_date: Time.now }
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'with user already assigned' do
        it 'renders unathorized' do
          partner_access.update(user_id: user.id)
          put :register, params: { cpf: partner_access.cpf,
                                   birth_date: partner_access.birth_date }
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context 'without user' do
      it 'returns unauthorized' do
        put :register

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
