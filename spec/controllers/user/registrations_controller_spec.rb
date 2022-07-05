# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::RegistrationsController, type: :controller do
  let(:social_success) do
    success_response(id: '123', type: 'users', provider: 'facebook',
                     uid: '123', name: 'Social', email: 'social@login.com',
                     created_at: Time.now.utc.as_json, facebook_uid: '123',
                     options: {}, crm_email: 'social@login.com')
  end
  let(:social_error) do
    { 'status' => 'error',
      'success' => false,
      'errors' => [t('errors.messages.validate_sign_up_params')] }
  end

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'POST create' do
    context 'social registration' do
      context 'with valid token' do
        before do
          Timecop.freeze(Time.now)
          @request.headers[:client] = 'WEB'
          allow(HTTParty).to receive_message_chain(:get, :parsed_response)
            .and_return('id' => '123',
                        'email' => 'social@login.com',
                        'name' => 'Social')
          mock_intercom_create_user
          expect(PersistCrmEventWorker).to receive(:perform_async)
          expect(CrmRdstationSignupEventWorker).to receive(:perform_async)
            .with('123', @request.headers[:client])
          expect(SendConfirmationWorker).to receive(:perform_async)
        end

        let(:valid_params) do
          { provider: 'facebook', uid: '123', email: 'social@login.com',
            token: 'tOkEn', crm_email: 'social@login.com' }
        end

        it 'creates a new user registration', :vcr do
          post :create, params: valid_params

          assert_registration_response(:created, social_success)
          expect(response.headers.keys).to include_authorization_keys
        end
      end

      context 'with invalid attributes' do
        before do
          allow(HTTParty).to receive_message_chain(:get, :parsed_response)
            .and_return(social_error)
        end
        let(:invalid_params) do
          { 'provider' => 'facebook', 'token' => 'invalid' }
        end

        it 'returns an error hash with unprocessable entity status' do
          post :create, params: invalid_params

          assert_registration_response(:unprocessable_entity, social_error)
          expect(response.headers.keys).not_to include_authorization_keys
        end
      end
    end
  end

  # rubocop:disable Metrics/AbcSize
  def assert_registration_response(status, result)
    expect(response.content_type).to eq('application/json')
    expect(response).to have_http_status(status)
    result['data']['attributes']['token'] = User.last.token unless result['status']
    expect(parsed_response).to eq(result)
  end
  # rubocop:enable Metrics/AbcSize
end
