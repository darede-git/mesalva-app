# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'reset password' do |entity|
  entity.each do |role|
    describe role.classify.constantize::PasswordsController,
             type: :controller do
      before { @request.env['devise.mapping'] = Devise.mappings[role.to_sym] }
      before { ActionMailer::Base.deliveries.clear }
      describe 'POST #create' do
        context "with valid #{role} should send a request to reset password" do
          it 'issue an email and returns a valid message' do
            resource = create(role.to_sym, password: '12345678')
            authentication_headers_for(resource)
            expect do
              post :create, params: { email: resource.email }
            end.to change(ActionMailer::Base.deliveries, :count).by(1)
            expect(ActionMailer::Base.deliveries.last.subject).to eq(
              'Recuperação de Senha - Me Salva!'
            )
            assert_type_and_status(:success)
          end
        end

        if role == 'user'
          context "with valid #{role}-platform should send a request to reset password" do
            before { user_platform_session }
            it 'issue an email and returns a valid platform message' do
              expect do
                post :create, params: { email: user_platform.user.email,
                                        platform_slug: user_platform.platform.slug }
              end.to change(ActionMailer::Base.deliveries, :count).by(1)
              expect(ActionMailer::Base.deliveries.last.subject).to eq('Recuperação de Senha'\
              ' - Example Platform!')
              expect(ActionMailer::Base.deliveries.last['redirect-url'].value).to eq('https://'\
              'platform.ms')
              assert_type_and_status(:success)
            end
          end
        end

        context "with a invalid #{role} send a request to reset password" do
          it 'issue an email and returns a valid message' do
            expect do
              post :create, params: { email: 'nonexistent@email.com' }
            end.to change(ActionMailer::Base.deliveries, :count).by(0)

            assert_type_and_status(:bad_request)
          end
        end
      end

      describe 'PUT #update' do
        context 'reset password with valid attributes' do
          it "returns an #{role} with valid message" do
            resource = create(role.to_sym,
                              reset_password_token: '4b75d825ca800'\
                              '348a5526ea7d990b0a5e1850bc2a25297c8'\
                              '574e64b544cd561f',
                              password: '12345678')
            put :update, params: { reset_password_token: 'zyvuiRYwNNuPJp9iiV1w',
                                   password: '87654321',
                                   password_confirmation: '87654321' }

            assert_jsonapi_response(:success,
                                    resource,
                                    "#{role.classify}Serializer".constantize)
          end
        end

        context 'reset password with unauthorized token' do
          it 'returns http unauthorized' do
            put :update, params: { reset_password_token: 'invalid',
                                   password: '87654321',
                                   password_confirmation: '87654321' }

            assert_type_and_status(:unauthorized)
          end
        end

        context 'reset password without password confirmation' do
          it 'returns http unprocessable entity' do
            create(role.to_sym,
                   reset_password_token: '4b75d825ca800'\
                   '348a5526ea7d990b0a5e1850bc2a25297c8'\
                   '574e64b544cd561f',
                   password: '12345678')
            put :update, params: { reset_password_token: 'zyvuiRYwNNuPJp9iiV1w',
                                   password: '' }

            assert_type_and_status(:unprocessable_entity)
          end
        end
      end
    end
  end
end

RSpec.describe BasePasswordsController, type: :controller do
  describe 'per context' do
    it_should_behave_like 'reset password', %w[user teacher admin]
  end
end
