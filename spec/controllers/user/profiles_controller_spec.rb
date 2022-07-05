# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::ProfilesController, type: :controller do
  include ActionDispatch::TestProcess

  let(:url) do
    'https://cdnqa.mesalva.com/uploads/platforms/' \
      '%3Aplatform_slug/medium/integration.jpeg'
  end
  let!(:user) { create(:user) }
  let!(:multiple_provider_user) { create(:multiple_provider_user) }
  let!(:admin) { create(:admin) }
  let!(:objective) { create(:objective) }
  let!(:address) { create(:address) }

  describe 'PUT #update' do
    context 'a visitor' do
      it 'cannot update the requested user' do
        put :update, params: { objective_id: objective.id }

        assert_status_response('unauthorized')
      end
    end

    context 'an user' do
      before { authentication_headers_for(user) }

      context 'with valid net promoter score' do
        it 'creates a new NPS' do
          mock_intercom_update_user
          expect do
            put :update, params: {
              id: user,
              net_promoter_scores_attributes: [score: '9',
                                               reason: 'Amo o Me Salva!']
            }
          end.to change(NetPromoterScore, :count).by(1)

          assert_headers_for(user)
          assert_type_and_status(:ok)
        end
      end

      context 'updating permitted attributes' do
        before { mock_intercom_update_user }

        context 'without address attributes' do
          it 'updates the requested user' do
            assert_intercom_worker_call('Update')

            put :update, params: {
              id: user,
              objective_id: objective.id,
              image: 'data:image/jpeg;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAA'\
'BCAYAAAAfFcSJAAAADUlEQVR42mP4z8DwHwAFAAH/VscvDQAAAABJRU5ErkJggg==',
              phone_area: '51',
              phone_number: '999999999',
              profile: 'teacher'
            }

            user.reload
            assert_headers_for(user)
            assert_jsonapi_response(:ok, user, UserSerializer, user_includes)
          end
        end

        context 'with enem_subscription_id' do
          it 'update filed' do
            put :update, params: { enem_subscription_id: '000000000000' }

            assert_headers_for(user)
            assert_jsonapi_response(:ok, user.reload, UserSerializer, user_includes)
          end
        end

        context 'with address attributes' do
          context 'when the user does not have an address' do
            it 'creates a new address' do
              expect do
                put :update, params: {
                  id: user,
                  address_attributes: {
                    street: 'Rua Padre Chagas',
                    street_number: 79,
                    street_detail: '302',
                    neighborhood: 'Moinhos de Vento',
                    city: 'Porto Alegre',
                    zip_code: '91920-000',
                    state: 'RS',
                    country: 'Brasil',
                    area_code: '11',
                    phone_number: '979911992'
                  }
                }
              end.to change(Address, :count).by(1)

              assert_headers_for(user)
              assert_type_and_status(:ok)
              expect(parsed_response['data']['relationships'])
                .to include('address')
              expect(parsed_response['included'][0]['type'])
                .to eq('addresses')
            end
          end

          context 'when the user has an address' do
            before do
              user.address = address
              user.save
            end
            it 'updates the address' do
              expect do
                put :update, params: {
                  id: user,
                  address_attributes: {
                    id: address.id,
                    street: 'Nova rua'
                  }
                }
              end.to change(Address, :count)
                .by(0).and change { user.reload.address.street }
                .from('Rua Padre Chagas').to('Nova rua')

              assert_headers_for(user)
              assert_type_and_status(:ok)
              expect(parsed_response['data']['relationships'])
                .to include('address')
            end
          end
        end

        context 'with options attributes' do
          let!(:platform) { create(:platform) }
          context 'and valid main_platform_id' do
            it 'updates the main_platform_id' do
              expect do
                put :update, params: {
                  id: user,
                  options: {
                    main_platform_id: platform.id
                  }
                }
                assert_headers_for(user)
                assert_type_and_status(:ok)
                expect(parsed_response['data']['attributes'])
                  .to include('options'['main_platform_id'])
              end
            end
          end
        end

        context 'when the user has scholar record' do
          let!(:scholar_record) do
            create(:scholar_record, :with_school, user: user)
          end

          context 'and update objective' do
            before do
              expect(PersistCrmEventWorker).to receive(:perform_async)
              expect(CrmRdstationObjectiveChangeEventWorker).to receive(
                :perform_in
              ).with(1.second, user.uid, objective.id)
            end

            it 'disables last scholar record' do
              put :update, params: { id: user, objective_id: objective.id }

              expect(scholar_record.reload.active).to eq(false)
            end
          end

          context 'and dont update objective' do
            let(:name) { 'Outro nome' }
            it 'updates the requested user' do
              put :update, params: { id: user, name: name }

              expect(scholar_record.reload.active).to eq(true)
              expect(user.reload.name).to eq(name)
            end
          end
        end

        it_behaves_like 'a email update for social provider', %w[facebook
                                                                 google]
      end
    end

    context 'an admin' do
      before { authentication_headers_for(admin) }

      context 'updating permitted attributes' do
        it 'updates the requested user' do
          assert_intercom_worker_call('Update')
          put :update, params: { uid: user.uid, name: 'Another name' }

          assert_headers_for(admin)
          assert_type_and_status(:ok)
          expect(parsed_response['data']['attributes']['name'])
            .to eq 'Another name'
          expect(parsed_response['data']['attributes']['uid']).to eq(user.uid)
        end
      end

      context 'updating a user objective' do
        let!(:objetive) { create(:objective) }

        context 'with scholar record' do
          let!(:scholar_record) do
            create(:scholar_record, :with_school, user: user)
          end

          it 'dont disables last scholar record' do
            put :update, params: { uid: user.uid, objective_id: objective.id }

            expect(scholar_record.reload.active).to eq(true)
          end
        end

        context 'without scholar record' do
          it 'updates objective' do
            put :update, params: { uid: user.uid, objective_id: objective.id }

            assert_type_and_status(:ok)
            expect(user.reload.objective).to eq(objective)
          end
        end
      end
    end
  end

  describe 'GET #show' do
    context 'a visitor' do
      it 'cannot see his profile' do
        get :show
        assert_status_response('unauthorized')
      end

      it 'cannot see an user profile' do
        get :show, params: { uid: user.uid }

        assert_status_response('unauthorized')
        expect(response.headers.keys).not_to include_authorization_keys
      end
    end

    context 'an user' do
      before do
        authentication_headers_for(user)
      end

      it 'can see his own profile' do
        get :show

        assert_jsonapi_response(:ok, user, UserSerializer, user_includes)
        expect(parsed_response['data']['id']).to eq(user.uid)
      end

      it 'cannot see another user profile' do
        get :show, params: { uid: 'another@mesalva.com' }

        assert_status_response('forbidden')
        assert_headers_for(user)
      end

      it 'cannot see facebook uid' do
        get :show

        assert_jsonapi_response(:ok, user, UserSerializer, user_includes)
        expect(parsed_response['data']['attributes']['facebook-uid']).to be_nil
        expect(parsed_response['data']['attributes']['google-uid']).to be_nil
      end
    end

    context 'an admin' do
      before do
        authentication_headers_for(admin)
      end

      it_behaves_like 'a logged profile' do
        let(:user_role) { user }
        let(:user_role_logged) { admin }
      end

      it 'can see user facebook and google uid' do
        get :show, params: { uid: multiple_provider_user.uid }

        assert_headers_for(admin)
        assert_type_and_status(:ok)

        expect(parsed_response['data']['attributes']['facebook-uid'])
          .to eq(multiple_provider_user.facebook_uid.to_s)

        expect(parsed_response['data']['attributes']['google-uid'])
          .to eq(multiple_provider_user.google_uid.to_s)
      end
    end
  end

  def user_includes
    %i[address academic_info education_level objective phone_area phone_number options]
  end
end
