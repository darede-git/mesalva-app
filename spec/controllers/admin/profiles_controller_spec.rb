# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ProfilesController, type: :controller do
  include ActionDispatch::TestProcess
  include StubHelper

  let(:admin) { create(:admin) }
  let(:url) { admin.image.url }

  let(:ex_admin) { create(:admin, name: 'Another Admin') }
  let(:success_response) do
    { 'data' => { 'id' => admin.uid,
                  'type' => 'admins',
                  'attributes' => { 'uid' => admin.uid,
                                    'name' => 'João Bolão',
                                    'image' => { 'url' => url },
                                    'email' => admin.email,
                                    'description' => 'This is an admin!',
                                    'birth-date' => '26-02-1994',
                                    'role' => 'dev',
                                    'active' => true } } }
  end
  let(:blank_email_error_response) do
    { 'errors' => [{ 'email' => [t('errors.messages.blank')] }] }
  end
  let(:invalid_email_error_response) do
    { 'errors' => [{ 'email' => [t('errors.messages.not_email')] }] }
  end
  let(:invalid_attributes) { { email: '' } }

  describe 'PUT #update' do
    before { admin_session }
    context '.update' do
      context 'an admin' do
        context 'with valid params' do
          context 'updating himself' do
            context 'updates the requested admin' do
              it_behaves_like 'updates the logged user' do
                let(:user_role) { admin }
              end
            end
          end

          context 'update role' do
            it 'succefully' do
              expect(DestroyIntercomUserWorker).not_to receive(:perform_async)

              put :update, params: { uid: ex_admin.uid, active: ex_admin.role }

              assert_headers_for(admin)
              assert_type_and_status(:ok)
              expect(parsed_response['data']['id']).to eq(ex_admin.uid)
              expect(parsed_response['data']['attributes']['role'])
                .to eq('dev')
            end
          end

          context 'deactivating another admin' do
            it 'updates the requested admin' do
              expect(DestroyIntercomUserWorker).not_to receive(:perform_async)

              put :update, params: { uid: ex_admin.uid, active: false }

              assert_headers_for(admin)
              assert_type_and_status(:ok)
              expect(parsed_response['data']['id']).to eq(ex_admin.uid)
              expect(parsed_response['data']['attributes']['active'])
                .to eq(false)
            end
          end
        end

        context 'with invalid params' do
          it 'when email is blank' do
            put :update, params: { uid: admin.uid, email: '' }

            assert_action_response(blank_email_error_response,
                                   :unprocessable_entity)
          end

          it 'when email is typed incorrectly' do
            put :update, params: { uid: admin.uid, email: 'abc@gmail' }

            assert_action_response(invalid_email_error_response,
                                   :unprocessable_entity)
          end
        end
      end
    end
  end

  describe 'GET #show' do
    context 'an user' do
      it 'cannot see an admin profile' do
        user = create(:user)
        authentication_headers_for(user)
        get :show, params: { uid: admin.uid }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'an admin' do
      before { authentication_headers_for(admin) }

      it_behaves_like 'a logged profile' do
        let(:user_role) { admin }
        let(:user_role_logged) { admin }
      end

      it 'can see another admin profile' do
        another_admin = create(:admin)
        get :show, params: { uid: another_admin.uid }

        assert_headers_for(admin)
        assert_type_and_status(:ok)
        expect(parsed_response['data']['id']).to eq(another_admin.uid.to_s)
      end
    end
  end

  describe 'GET #index' do
    context 'an user' do
      it 'cannot see an admin profile' do
        user = create(:user)
        authentication_headers_for(user)
        get :index, params: { uid: admin.uid }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'an admin' do
      before { authentication_headers_for(admin) }
      let!(:another_admin1) { create(:admin, role: 'manager') }
      let!(:another_admin2) { create(:admin, role: 'teacher') }

      it_behaves_like 'a logged profile' do
        let(:user_role) { admin }
        let(:user_role_logged) { admin }
      end

      it 'can see another admin profile filtered by role' do
        get :index, params: { role: 'manager' }

        assert_headers_for(admin)
        assert_type_and_status(:ok)
        expect(parsed_response['data'].first['id']).to eq(another_admin1.uid.to_s)
      end

      it 'can see another admin profile filtered by uid like' do
        get :index, params: { uid: another_admin1.uid[0..7] }

        assert_headers_for(admin)
        assert_type_and_status(:ok)
        expect(parsed_response['data'].first['id']).to eq(another_admin1.uid.to_s)
      end

      it 'can see another admin profile filtered by name like' do
        get :index, params: { name: another_admin2.name[0..7] }

        assert_headers_for(admin)
        assert_type_and_status(:ok)
        expect(parsed_response['data'].first['id']).to eq(another_admin2.uid.to_s)
      end
    end
  end
end
