# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'invite someone' do |entity|
  entity.each do |role|
    describe role.classify.constantize::InvitationsController,
             type: :controller do
      before { @request.env['devise.mapping'] = Devise.mappings[role.to_sym] }
      let!(:admin) { create(:admin, email: 'admin@mesalva.com') }
      let(:valid_response) do
        { 'data' => { 'id' => 'invite@email.com',
                      'type' => role.pluralize,
                      'attributes' => { 'uid' => 'invite@email.com',
                                        'name' => 'invite',
                                        'image' => { 'url' => nil },
                                        'email' => 'invite@email.com',
                                        'description' => nil,
                                        'birth-date' => nil,
                                        'active' => true } } }
      end

      let(:valid_response_admin) do
        { 'data' => { 'id' => 'invite@email.com',
                      'type' => role.pluralize,
                      'attributes' => { 'uid' => 'invite@email.com',
                                        'name' => 'invite',
                                        'image' => { 'url' => nil },
                                        'email' => 'invite@email.com',
                                        'description' => nil,
                                        'birth-date' => nil,
                                        'role' => nil,
                                        'active' => true } } }
      end

      describe 'POST #create' do
        context "as an admin inviting a new #{role} with valid attributes" do
          it "creates a new #{role} by invite" do
            admin_session

            assert_invite_creation(role.classify)
            if role == 'admin'
              expect(parsed_response).to eq(valid_response_admin)
            else
              expect(parsed_response).to eq(valid_response)
            end
          end
        end

        context 'when is an duplicated invitation' do
          it 'return http unprocessable entity' do
            admin_session
            role.classify.constantize.invite!(
              { email: 'invite@email.com', name: 'invite' }, admin
            )

            expect do
              post :create, params: { email: 'invite@email.com',
                                      name: 'invite' }
            end.to change(role.classify.constantize, :count).by(0)

            assert_type_and_status(:unprocessable_entity)
          end
        end

        context 'without authentication and with valid attributes' do
          it 'returns http unauthorized' do
            expect do
              post :create, params: { email: 'invite@email.com',
                                      name: 'invite' }
            end.to change(role.classify.constantize, :count).by(0)

            expect(response).to have_http_status(:unauthorized)
            expect(response.headers.keys).not_to include_authorization_keys
          end
        end
      end

      describe 'PUT #update' do
        context "as a(n) #{role}" do
          let(:invited_resource) do
            role.classify.constantize
                .invite!(email: 'accept@email.com', name: 'accept')
          end

          context 'accepting an invitation with valid attributes' do
            it "creates a new #{role} by invite" do
              @request.headers[:client] = 'WEB'
              assert_accept_invite('12345678', '12345678',
                                   invited_resource.raw_invitation_token,
                                   { 'success' =>
                                     [t('devise.invitations.updated')] },
                                   'success')
            end
          end

          context 'with invalid passwords' do
            let(:invalid_password) do
              { 'errors' =>
                [t('devise_token_auth.passwords.invalid_password')] }
            end
            let(:unprocessable_entity) { 'unprocessable_entity' }
            context 'with blank password' do
              it 'returns http code unprocessable entity' do
                assert_accept_invite('', '',
                                     invited_resource.raw_invitation_token,
                                     invalid_password, unprocessable_entity)
                expect(response.headers.keys).not_to include_authorization_keys
              end
            end

            context 'with password equals nil' do
              it 'returns http code unprocessable entity' do
                assert_accept_invite(nil, nil,
                                     invited_resource.raw_invitation_token,
                                     invalid_password, unprocessable_entity)
                expect(response.headers.keys).not_to include_authorization_keys
              end
            end

            context 'with password length less than 6' do
              it 'returns http code unprocessable entity' do
                assert_accept_invite('12345', '12345',
                                     invited_resource.raw_invitation_token,
                                     invalid_password, unprocessable_entity)
                expect(response.headers.keys).not_to include_authorization_keys
              end
            end
          end

          context 'with invalid token' do
            it 'returns http code unprocessable entity' do
              assert_accept_invite(
                '12345678', '12345678', 'invalid',
                { 'errors' => [t('devise.failure.unauthenticated')] },
                'unauthorized'
              )
              expect(response.headers.keys).not_to include_authorization_keys
            end
          end
        end
      end
    end
  end
end

RSpec.describe BaseInvitationsController, type: :controller do
  include InvitationAssertionHelper

  describe 'per context' do
    it_should_behave_like 'invite someone', %w[teacher admin]
  end
end
