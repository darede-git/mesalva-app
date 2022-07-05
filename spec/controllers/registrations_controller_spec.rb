# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'to register someone' do |entity|
  entity.each do |role|
    describe role.classify.constantize::RegistrationsController,
             type: :controller do
      before { @request.env['devise.mapping'] = Devise.mappings[role.to_sym] }
      let!(:resource) do
        create(role.to_sym, email: 'admin@mesalva.com')
      end
      let(:valid_session) { authentication_headers_for(resource) }
      let!(:valid_registration) do
        { name: 'User Name', email: 'teste@teste.com', password: '123123123' }
      end
      let!(:invalid_registration) { { email: t('errors.messages.not_email') } }
      let(:resource_response) do
        { 'data' => { 'id' => 'teste@teste.com',
                      'type' => role.pluralize,
                      'attributes' => { 'uid' => 'teste@teste.com',
                                        'name' => 'Resource Name',
                                        'image' => { 'url' => nil },
                                        'email' => 'teste@teste.com',
                                        'description' => nil,
                                        'birth-date' => nil,
                                        'active' => true,
                                        'facebook-uid' => nil,
                                        'google-uid' => nil,
                                        'phone-area' => nil,
                                        'phone-number' => nil } } }
      end
      let(:user_response) do
        success_response(id: 'teste@teste.com', type: role.pluralize,
                         provider: 'email', uid: 'teste@teste.com',
                         email: 'teste@teste.com', crm_email: 'teste@teste.com',
                         name: 'User Name', created_at: Time.now.utc.as_json, options: {})
      end
      let(:error_response) do
        { 'errors' => [{ 'email' => [t('errors.messages.not_email'),
                                     t('errors.messages.invalid')] }] }
      end

      describe 'POST create' do
        context 'email registration' do
          context 'with valid attributes' do
            it "creates a new #{role} registration" do
              if role == 'user'
                Timecop.freeze(Time.now) do
                  expect(CreateIntercomUserWorker).to receive(:perform_async)
                    .with(User.last.id + 1, User, [[:subscriber, 0],
                                                   [:client, 'WEB'],
                                                   [:utm_source, nil],
                                                   [:utm_medium, nil],
                                                   [:utm_term, nil],
                                                   [:utm_content, nil],
                                                   [:utm_campaign, nil]])

                  create_registration(valid_registration,
                                      :created, user_response)
                end
              else
                create_registration(valid_registration, :created,
                                    resource_response)
              end
              expect(response.headers.keys).to include_authorization_keys
            end
          end

          context 'with invalid attributes' do
            it 'returns http status unprocessable entity' do
              create_registration(invalid_registration, :unprocessable_entity,
                                  error_response)
              expect(response.headers.keys).not_to include_authorization_keys
            end
          end
        end
      end
    end
  end

  def create_registration(attributes, http_status, entity_response)
    valid_session
    post :create, params: attributes
    entity_response['data']['attributes']['token'] = User.last.token if attributes[:name]
    assert_action_response(entity_response, http_status)
  end
end

RSpec.describe BaseRegistrationsController, type: :controller do
  describe 'per context' do
    it_should_behave_like 'to register someone', %w[user]
  end
end
