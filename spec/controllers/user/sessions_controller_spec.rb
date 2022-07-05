# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::SessionsController, type: :controller do
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  include_context 'session'

  let(:user) { create(:facebook_user) }

  let(:resource) do
    create(:user, email: resource_email, password: password)
  end

  let(:resource_response) do
    session_success(resource)
  end

  let(:invalid_platform_response) do
    { 'errors' => [I18n.t('errors.messages.invalid_platform')] }
  end

  describe 'POST create' do
    context 'social session' do
      before { @request.headers[:client] = 'WEB' }
      context 'with valid token' do
        before do
          Timecop.freeze(Time.now)
          mock_http_party(httparty_response(user))
          mock_intercom_create_user
          expect(PersistCrmEventWorker).to receive(:perform_async)
          expect(CrmRdstationSignupEventWorker).to receive(:perform_async)
            .with(user.uid, @request.headers[:client])
          assert_update_intercom_user_worker(user.id)
        end

        let(:valid_params) do
          { 'provider' => user.provider, 'uid' => user.uid,
            'email' => user.email, 'token' => 'tOkEn' }
        end

        it 'creates a new user session', :vcr do
          post :create, params: valid_params

          expect(user.reload.sign_in_count).to eq(1)
          assert_action_response(social_session_success(user), :accepted)
          assert_headers_for(user)
        end
      end

      context 'with invalid attributes' do
        before do
          mock_http_party(httparty_response)
        end

        let(:invalid_params) do
          { 'provider' => 'facebook', 'token' => 'invalid' }
        end

        it 'returns an error hash with unprocessable entity status' do
          post :create, params: invalid_params

          assert_action_response(error_response, :unprocessable_entity)
          expect(response.headers.keys).not_to include_authorization_keys
        end
      end

      context 'when user already has email registration' do
        let!(:email_user) do
          create(:user, email: 'dup@user.com', name: 'Duplicated',
                        sign_in_count: 2)
        end
        let(:social_params) do
          { 'provider' => 'facebook',
            'uid' => '123',
            'email' => 'dup@user.com',
            'token' => 'tOkEn' }
        end

        context 'first login' do
          let(:httparty) do
            { 'id' => '123', 'email' => 'dup@user.com', 'name' => 'Social' }
          end

          before do
            mock_http_party(httparty)
            mock_intercom_create_user
            expect(PersistCrmEventWorker).to receive(:perform_async)
            expect(CrmRdstationSignupEventWorker).to_not receive(:perform_async)
          end

          before do
            event = double
            expect(MeSalva::Crm::Rdstation::Event::Client).to receive(:new)
              .with({ user: email_user, event_name: 'sign_in|web', payload: {} }).and_return(event)
            expect(event).to receive(:create)
          end

          it 'merge both users' do
            expect do
              post :create, params: social_params
            end.to change { email_user.reload.facebook_uid }.from(nil).to('123')
                                                            .and change(User, :count).by(0)

            assert_jsonapi_response(:accepted, email_user, UserSerializer)
            assert_headers_for(email_user)
          end
        end

        context 'email authorization from provider changes after '\
          'registration' do
          let!(:social_user) do
            create(:facebook_user, email: nil)
          end

          let(:httparty) do
            httparty_response(social_user)
              .merge('email' => social_params['email'])
          end

          before do
            mock_http_party(httparty)
          end

          it 'returns social user session', :vcr do
            expect do
              post :create, params: social_params
            end.to change(User, :count).by(0)
            expect(social_user.reload.email).to eq(nil)
            assert_action_response(social_session_success(social_user),
                                   :accepted)
          end
        end
      end
    end

    context 'email session' do
      context 'with valid attributes' do
        context 'when provider is email' do
          before do
            assert_update_intercom_user_worker(resource.id)
          end

          before do
            event = double
            expect(MeSalva::Crm::Rdstation::Event::Client).to receive(:new)
              .with({ user: resource, event_name: 'sign_in|web', payload: {} }).and_return(event)
            expect(event).to receive(:create)
          end

          context 'normal email' do
            let(:email) { resource_email }
            it_behaves_like 'a valid session'
          end

          context 'upcase email' do
            let(:email) { resource_email.upcase }
            it_behaves_like 'a valid session'
          end
        end

        context 'with social provider' do
          let!(:social_user) do
            create(:facebook_user, password: password)
          end

          let(:valid_attributes) do
            { email: social_user.email, password: password }
          end

          before do
            Timecop.freeze(Time.now)
            assert_update_intercom_user_worker(social_user.id)
            @request.headers[:client] = 'WEB'
          end

          it 'creates a new session', :vcr do
            post :create, params: valid_attributes

            expect(response.headers.keys).to include_authorization_keys
            assert_action_response(social_session_success(social_user),
                                   :accepted)
          end
        end
      end

      context 'with invalid attributes' do
        it_behaves_like 'an unauthorized session for inactive resource'
        it_behaves_like 'an unauthorized session for invalid credentials'
        it_behaves_like 'an unauthorized session for an inexistent resource'
      end
    end
  end

  describe 'DELETE #destroy' do
    it_behaves_like 'a session destroyer'
  end

  describe 'POST #cross_platform' do
    context 'user is loged in' do
      before { user_session }
      context 'with a valid platform as parameter' do
        it 'should return a session' do
          post :cross_platform, params: { platform: 'IOS' }

          expect(parsed_response['access-token']).not_to be_nil
          expect(parsed_response['client']).to eq('IOS')
          expect(parsed_response['token-type']).to eq('Bearer')
          expect(parsed_response['uid']).to eq(user.uid)
          expect(user.reload.valid_token?(parsed_response['access-token'],
                                          'IOS'))
            .to be_truthy
        end
      end

      context 'with an invalid platform as parameter' do
        it 'returns http status unauthorized' do
          post :cross_platform, params: { platform: 'WINDOWS' }

          assert_action_response(invalid_platform_response,
                                 :unprocessable_entity)
        end
      end

      context 'with current platform as parameter' do
        it 'returns http status unauthorized' do
          post :cross_platform, params: { platform: 'WEB' }

          assert_type_and_status(:unprocessable_entity)
        end
      end
    end

    context 'as guest' do
      it 'returns http status unauthorized' do
        post :cross_platform, params: { platform: 'IOS' }

        assert_type_and_status(:unauthorized)
      end
    end
  end

  def httparty_response(user = nil)
    { 'id' => user.try(:uid),
      'email' => user.try(:email),
      'name' => user.try(:name) }
  end

  def session_attributes(user)
    { id: user.uid, type: 'users', provider: user.provider, token: user.token,
      uid: user.uid, name: user.name, email: user.email, options: {}, crm_email: user.crm_email,
      enem_subscription_id: user.enem_subscription_id, created_at: user.created_at.utc.as_json }
  end

  def session_success(user)
    success_response(session_attributes(user))
  end

  def social_session_success(user)
    success_response(session_attributes(user).merge(facebook_uid: '123'))
  end

  def assert_update_intercom_user_worker(user_id)
    expect(UpdateIntercomUserWorker).to receive(:perform_async)
      .with(user_id, User, [[:client, 'WEB'],
                            [:utm_source, nil],
                            [:utm_medium, nil],
                            [:utm_term, nil],
                            [:utm_content, nil],
                            [:utm_campaign, nil]])
  end
end
