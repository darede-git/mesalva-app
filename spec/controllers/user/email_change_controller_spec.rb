# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::EmailChangeController, type: :controller do
  before { user_platform_session }

  context '#create' do
    context 'valid params' do
      let(:valid_params) do
        { new_email: 'new@email.com',
          password: 'password' }
      end

      before { user_platform.user.update(password: 'password') }

      it 'renders ok' do
        post :create, params: valid_params
        expect(response).to have_http_status(:ok)
      end
      it 'creates email change' do
        post :create, params: valid_params

        user_platform.user.reload
        expect(user_platform.user.options['new-email']).to eq(valid_params[:new_email])
        expect(user_platform.user.options['new-email-token']).not_to be_nil
      end

      context 'send email change' do
        before do
          Timecop.freeze(Time.now)
          @request.headers[:client] = 'WEB'
          allow(HTTParty).to receive_message_chain(:request, :status)
            .and_return(200)
          expect(SendEmailChangedWorker).to receive(:perform_async)
        end
      end
    end

    context 'invalid params' do
      let(:invalid_params) { { password: user.password } }

      it 'renders unprocessable entity' do
        post :create, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context '#confirm' do
    let(:crm_users_double) { double }
    before do
      allow(MeSalva::Crm::Rdstation::Users).to receive(:new).and_return(crm_users_double)
      allow(MeSalva::Crm::Users).to receive(:new).and_return(crm_users_double)
      allow(crm_users_double).to receive(:access_token).and_return(true)
      allow(crm_users_double).to receive(:update_attribute).and_return(true)
      allow(crm_users_double).to receive(:update).and_return(true)
    end

    context 'valid params' do
      let(:valid_params) { { token: 'new-email-token' } }

      before do
        user_platform.user.options['new-email'] = 'new-email@mesalva.com'
        user_platform.user.options['new-email-token'] = valid_params[:token]
        user_platform.user.save
      end

      it 'changes user email' do
        post :confirm, params: valid_params

        expect(response).to have_http_status(:ok)
        expect(user_platform.user.reload.email).to eq('new-email@mesalva.com')
        expect(user_platform.user.reload.confirmed?).to be_truthy
      end
    end

    context 'invalid params' do
      context 'wrong token' do
        let(:invalid_params) { { token: '1234' } }
        it 'renders unathorized' do
          allow(MeSalva::Crm::Rdstation::Users).to receive(:new).and_return(crm_users_double)

          post :confirm, params: invalid_params

          expect(response).to have_http_status(:unauthorized)
        end
      end
      context 'missing token' do
        let(:invalid_params) { {} }
        it 'renders unathorized' do
          post :confirm, params: invalid_params

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
