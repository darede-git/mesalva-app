# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Teacher::ProfilesController, type: :controller do
  include ActionDispatch::TestProcess

  let(:success_response) do
    { 'data' => { 'id' => teacher.uid,
                  'type' => 'teachers',
                  'attributes' => { 'uid' => teacher.uid,
                                    'name' => 'João Bolão',
                                    'image' => { 'url' => teacher.image.url },
                                    'email' => teacher.email,
                                    'description' => 'This is an teacher!',
                                    'birth-date' => '26-02-1994',
                                    'active' => true } } }
  end
  let(:error_response) { { 'errors' => ['Forbidden parameters.'] } }

  describe 'PUT #update' do
    describe 'PUT #update' do
      context 'an user' do
        it 'cannot update a teacher' do
          user_session

          put :update,
              params: { birth_date: 'Tue, 26 Feb 1994',
                        name: 'João Bolão',
                        image: 'data:image/jpeg;base64,iVBORw0KGgoAAAANSUhEUg'\
'AAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP4z8DwHwAFAAH/VscvDQAAAABJRU5ErkJggg==' }

          assert_status_response('unauthorized')
          expect(response.headers.keys).not_to include_authorization_keys
        end
      end

      context 'a teacher' do
        before { teacher_session }

        context 'with valid params' do
          context 'updating his own profile' do
            context 'updates the requested teacher' do
              it_behaves_like 'updates the logged user' do
                let(:user_role) { teacher }
              end
            end
          end

          context 'updating another teacher profile' do
            it 'cannot update a teacher' do
              another_teacher = create(:teacher)
              expect(UpdateIntercomUserWorker).not_to receive(:perform_async)

              put :update,
                  params: { uid: another_teacher.uid,
                            birth_date: 'Tue, 26 Feb 1994',
                            name: 'João Bolão',
                            image: 'data:image/jpeg;base64,iVBORw0KGgoAAAA'\
'NSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP4z8DwHwAFAAH/VscvDQAAAABJRU5E'\
'rkJggg==' }

              assert_status_response('forbidden')
            end
          end
        end

        context 'with invalid params' do
          it 'return error' do
            expect(UpdateIntercomUserWorker).not_to receive(:perform_async)

            put :update, params: { email: '' }

            assert_action_response(
              { 'errors' => [{ 'email' => [t('errors.messages.blank')] }] },
              :unprocessable_entity
            )
          end
        end
      end

      context 'an admin' do
        before { authentication_headers_for(admin) }

        context 'updating permitted attributes' do
          it 'updates the requested teacher' do
            put :update, params: { uid: teacher.uid, active: false }

            assert_headers_for(admin)
            assert_type_and_status(:ok)
            expect(parsed_response['data']['attributes']['active']).to be_falsey
            expect(parsed_response['data']['attributes']['uid'])
              .to eq(teacher.uid)
          end
        end
      end
    end
  end

  describe 'GET #show' do
    context 'an user' do
      it 'cannot see a teacher profile' do
        user_session
        get :show, params: { uid: teacher.uid }

        expect(response).to have_http_status(:unauthorized)
        expect(response.headers.keys).not_to include_authorization_keys
      end
    end

    context 'an teacher' do
      before { authentication_headers_for(teacher) }

      it_behaves_like 'a logged profile' do
        let(:user_role) { teacher }
        let(:user_role_logged) { teacher }
      end

      it 'cannot see another teacher profile' do
        another_teacher = create(:teacher)

        get :show, params: { uid: another_teacher.uid }

        assert_type_and_status(:forbidden)
        expect(response.headers.keys).not_to include_authorization_keys
      end
    end
  end
end
