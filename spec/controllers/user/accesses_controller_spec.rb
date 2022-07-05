# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'correct accesses serialization' do
  it 'returns user accesses as serializer' do
    get :index

    assert_type_and_status(:success)
    expect(response.body).to eq(v2_access_serializer)
    expect(user.accesses.count).not_to eq(0)

    parsed_response['data'].each do |access|
      assert_access_order_foreign_key(access)
      assert_in_app_serialization_column(access)
    end
  end
end

RSpec.describe User::AccessesController, type: :controller do
  include PermissionHelper

  let!(:package) { create(:package_with_duration, :with_feature) }
  let!(:access_with_duration_and_node) do
    create(:access_with_duration_and_node,
           user_id: user.id)
  end

  let(:valid_attributes) do
    { user_uid: user.uid,
      package_id: package.id,
      duration: package.duration }
  end
  let(:invalid_attributes) do
    { user_uid: user.uid,
      duration: 5 }
  end

  describe 'GET index' do
    context 'as user' do
      before { user_session }

      context 'user does not have in_app orders' do
        it_behaves_like 'correct accesses serialization'
      end

      context 'user has in_app orders' do
        let(:in_app_order) do
          create(:in_app_order, user_id: user.id)
        end
        let!(:valid_access_from_in_app_purchase) do
          create(:access, :one_month, order_id: in_app_order.id,
                                      user_id: user.id,
                                      package_id: in_app_order.package.id)
        end

        it_behaves_like 'correct accesses serialization'
      end

      context 'user has an access from subscription package' do
        before do
          create(:access_with_subscription, user_id: user.id)
        end

        it 'returns user access with correct transparent expiration date' do
          get :index

          last_entity = parsed_response['data'].last
          expect(last_entity['attributes']['expires-at']
                  .to_time.utc.strftime('%Y/%m/%dT%H:%M:%S'))
            .to eq((user.accesses.last.expires_at - 3.days)
                  .strftime('%Y/%m/%dT%H:%M:%S'))
        end
      end

      context 'filter active accesses' do
        before do
          create(:access_with_duration_and_node,
                 user_id: user.id, active: false)
          create(:access_with_duration_and_node,
                 user_id: user.id,
                 starts_at: Time.now - 6.days,
                 expires_at: Time.now - 5.days)
        end
        let!(:gift) { create(:access_with_duration_and_node, user_id: user.id) }

        it 'returns user active access' do
          get :index, params: { valid: true }

          assert_apiv2_response(:ok,
                                [access_with_duration_and_node, gift],
                                V2::AccessSerializer,
                                %i[package package.features])
        end
      end
    end

    context 'as admin' do
      before { admin_session }
      it 'returns the accesses filtered by user_iud' do
        get :index, params: { user_uid: user.uid }

        assert_type_and_status(:success)
        expect(response.body).to eq(v2_access_serializer)

        expect(user.accesses.count).not_to eq(0)
      end
    end

    context 'without authentication' do
      it 'should returns http unauthorized' do
        get :index

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST create' do
    context 'as admin' do
      context 'with valid attributes' do
        it 'create a user access' do
          admin_session
          expect do
            post :create, params: valid_attributes
          end.to change(Access, :count).by(1)

          assert_jsonapi_response(:created, user.accesses.last)
        end
      end

      context 'with invalid attributes' do
        it 'returns http unprocessable entity' do
          admin_session
          expect do
            post :create, params: invalid_attributes
          end.to change(Access, :count).by(0)

          expect(response.content_type).to eq('application/json')
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'as user with valid attributes' do
      it 'returns http unauthorized' do
        user_session
        expect do
          post :create, params: valid_attributes
        end.to change(Access, :count).by(0)

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'without authentication' do
      it_behaves_like 'an unauthorized status' do
        let(:model) { Access }
      end
    end
  end

  describe 'PUT #update' do
    before { Timecop.freeze(Time.now) }
    let(:new_attributes) { { expires_at: Time.now + 1.year } }
    let(:inactive_attributes) { { active: false } }

    context 'as admin' do
      before { admin_session }
      context 'freeze an access' do
        it 'should deactivate the access' do
          put :update, params: { id: access_with_duration_and_node,
                                 freeze: true }

          assert_response_and_access_statuses(false)
        end
      end

      context 'unfreeze an access' do
        it 'should activate the access and update the expires date' do
          access_with_duration_and_node.active = false
          access_with_duration_and_node.remaining_days = 10
          access_with_duration_and_node.save
          put :update, params: { id: access_with_duration_and_node,
                                 unfreeze: true }

          assert_response_and_access_statuses(true)
        end
      end

      context 'with valid params' do
        it 'updates the requested access' do
          put :update, params: { id: access_with_duration_and_node,
                                 expires_at: Time.now + 1.year }

          access_with_duration_and_node.reload

          expect(access_with_duration_and_node.expires_at.to_i)
            .to eq new_attributes[:expires_at].to_i
          expect(response).to have_http_status(:ok)
        end
      end

      context 'deactivate a user access' do
        it 'updates the requested access to inactive' do
          put :update, params: { id: access_with_duration_and_node,
                                 active: false }

          assert_response_and_access_statuses(false)
        end
      end
    end

    context 'as user' do
      before { user_session }
      let(:freeze_attributes) { { freeze: true } }
      let(:unfreeze_attributes) { { freeze: false } }

      context 'freeze an access' do
        it 'should deactivate the access' do
          put :update, params: { id: access_with_duration_and_node,
                                 freeze: true }

          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'unfreeze an access' do
        it 'should activate the access and update the expires date' do
          put :update, params: { id: access_with_duration_and_node,
                                 freeze: false }

          expect(response).to have_http_status(:unauthorized)
        end
      end

      it 'returns http unauthorized' do
        put :update, params: { id: access_with_duration_and_node,
                               access: new_attributes }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'get full' do
    context 'as user' do
      before { user_session }
      context 'with permission' do
        before { grant_test_permission('full') }
        before { clean_db_for_tests }
        context 'created features' do
          let!(:feature_study_plan) { create(:feature, :study_plan) }
          let!(:feature_default_essay) { create(:feature, :default_essay) }
          let!(:feature_custom_essay) { create(:feature, :custom_essay) }
          let!(:feature_text_plan) { create(:feature, :text_plan) }
          let!(:feature_mentoring) { create(:feature, :mentoring) }
          let!(:feature_private_class) { create(:feature, :private_class) }
          let!(:feature_books) { create(:feature, :books) }

          context 'without features' do
            it 'returns the full user information' do
              expected_result = { essay: { has: false,
                                           default: false,
                                           unlimited: false,
                                           credits: 0,
                                           premium: false,
                                           text_plan: false },
                                  access: { has: false,
                                            duration: 0 },
                                  study_plan: { has: false },
                                  mentoring: { has: false },
                                  private_class: { has: false },
                                  books: { has: false } }
              get :full
              expect(response).to have_http_status(:ok)
              expect(JSON.parse(response.body)).to eq(JSON.parse(expected_result.to_json))
            end
          end
          context 'with all features' do
            context 'and package with all feature expected' do
              let!(:full_package) do
                create(:package_valid_with_price,
                       features: [feature_study_plan,
                                  feature_custom_essay,
                                  feature_text_plan,
                                  feature_mentoring,
                                  feature_private_class,
                                  feature_books])
              end
              context 'and accesses' do
                let!(:accesses) do
                  create(:access_with_expires_at,
                         package: full_package,
                         user: user,
                         expires_at: Date.today + 60.days)
                end

                it 'returns the full user information' do
                  expected_result = { essay: { has: true,
                                               default: false,
                                               unlimited: false,
                                               credits: 10,
                                               premium: true,
                                               text_plan: true },
                                      access: { has: true,
                                                duration: 60 },
                                      study_plan: { has: true },
                                      mentoring: { has: true },
                                      private_class: { has: true },
                                      books: { has: true } }
                  get :full
                  expect(response).to have_http_status(:ok)
                  expect(JSON.parse(response.body)).to eq(JSON.parse(expected_result.to_json))
                end
              end
            end
            context 'and package with some features and unlimited essay credits' do
              let!(:full_package) do
                create(:package_valid_with_price,
                       unlimited_essay_credits: true,
                       features: [feature_study_plan,
                                  feature_custom_essay,
                                  feature_text_plan])
              end
              context 'and accesses' do
                let!(:accesses) do
                  create(:access_with_expires_at,
                         package: full_package,
                         user: user,
                         expires_at: Date.today + 60.days)
                end

                it 'returns the full user information' do
                  expected_result = { essay: { has: true,
                                               default: false,
                                               unlimited: true,
                                               credits: 10,
                                               premium: true,
                                               text_plan: true },
                                      access: { has: true,
                                                duration: 60 },
                                      study_plan: { has: true },
                                      mentoring: { has: false },
                                      private_class: { has: false },
                                      books: { has: false } }
                  get :full
                  expect(response).to have_http_status(:ok)
                  expect(JSON.parse(response.body)).to eq(JSON.parse(expected_result.to_json))
                end
              end
            end
          end
        end
      end
    end
  end

  def assert_response_and_access_statuses(status)
    access_with_duration_and_node.reload
    expect(access_with_duration_and_node.active).to eq(status)
    expect(response).to have_http_status(:ok)
  end

  def assert_access_order_foreign_key(access)
    expect(order_by_access_as_json(access).token)
      .to eq(access['relationships']['order']['data']['id'])
  end

  def assert_in_app_serialization_column(access)
    expect(order_by_access_as_json(access).in_app_order?)
      .to eq(access['attributes']['in-app-subscription'])
  end

  def order_by_access_as_json(access_as_json)
    Access.find(access_as_json['id']).order
  end

  def v2_access_serializer
    V2::AccessSerializer.new(
      user.reload.accesses,
      include: %i[package package.features]
    ).serialized_json
  end

  def clean_db_for_tests
    Access.delete_all
    Price.delete_all
    Order.delete_all
    PackageFeature.delete_all
    Package.delete_all
    Feature.delete_all
  end
end
