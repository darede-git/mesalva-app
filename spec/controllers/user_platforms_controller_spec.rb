# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPlatformsController, type: :controller do
  let!(:package) { create(:package_valid_with_price) }
  let!(:included) { %i[platform_unity platform user] }

  describe 'Get Index' do
    before { user_platform_admin_session }
    let(:platform_student) do
      create(:user_platform,
             unity: 'SP', platform: user_platform_admin.platform)
    end
    let(:new_unity) { create(:platform_unity, name: 'SP', platform_id: user_platform.platform.id) }
    before do
      create(:user_platform, platform_unity_id: new_unity.id,
                             platform_id: user_platform.platform.id)
    end
    let!(:user_list) { create_list(:user_platform, 20, platform: user_platform_admin.platform) }
    context 'without filters' do
      it 'returns only user platforms on current platform' do
        get :index
        expect(parsed_response['meta']['users-count']).to eq(23)
      end
    end
    context 'with name filter' do
      it 'returns user platforms filtered by name like param' do
        get :index, params: { name: 'Me' }
        expect(parsed_response['meta']['users-count']).to eq(23)
      end
    end
    context 'with email filter' do
      it 'returns user platforms filtered by email' do
        get :index, params: { email: platform_student.user.email.gsub('@mesalva.com', '') }
        expect(parsed_response['meta']['users-count']).to eq(1)
        expect(parsed_response['data'].first['attributes']['email'])
          .to eq(platform_student.user.email)
      end
    end
    context 'with unity filter' do
      it 'returns user platforms filtered by unity' do
        get :index, params: { platform_slug: user_platform.platform.slug,
                              platform_unity_id: user_platform.platform_unity.id }

        expect(parsed_response['meta']['users-count']).to eq(1)
        first_row = parsed_response['data'].first['attributes']
        expect(first_row['platform-unity-id']).to eq(user_platform.platform_unity.id)
      end
    end
    context 'with role filter' do
      it 'returns user platforms filtered by role' do
        get :index, params: { platform_slug: user_platform_admin.platform.slug,
                              role: 'admin' }

        expect(parsed_response['meta']['users-count']).to eq(1)
        expect(parsed_response['data'].first['attributes']['role']).to eq('admin')
      end
    end
    context 'with all filters' do
      it 'returns user platforms filtered' do
        get :index, params: { unity: 'POA', email: user_list.first.user.email, name: 'Me', page: 1 }
        # get :index, params: { platform_slug: user_platform.platform.slug, name: 'Me',
        #                       platform_unity_slug: user_platform.platform_unity.slug,
        #                       email: user_platform.user.email, role: 'admin' }
        expect(parsed_response['meta']['users-count']).to eq(1)
      end
    end
  end

  describe '#CREATE' do
    describe 'when aiming to create a simple user' do
      context 'as admin' do
        context 'with valid params ' do
          before { user_platform_admin_session }
          it 'returns a created user , creates an access and a user_platform' do
            platform = user_platform_admin.platform.freeze
            platform_unity_slug = platform.platform_unities.first.slug.freeze
            post :create, params: { email: user.email, password: 'teste123',
                                    package_ids: package.id.to_s, role: 'student',
                                    unity: 'POA', platform_unity_slug: platform_unity_slug }

            access = Access.last
            user_platform = UserPlatform.where(user_id: user.id, platform_id: platform.id).take
            expect(access).to eq(Access.find_by(user_id: user.id))
            expect(access.platform_id).to eq(platform.id)
            assert_jsonapi_response(:created, user_platform, UserPlatformSerializer, included)
          end
        end

        context 'with invalid params' do
          before { user_platform_session }
          it 'return an error' do
            post :create, params: { password: 'teste123', email: user.email, role: 'superuser' }

            expect(response).to have_http_status(:unauthorized)
          end
        end
      end

      context 'as a user' do
        before { user_session }
        context 'with valid params' do
          it 'returns unauthorized' do
            post :create, params: { email: user.email, password: 'teste123',
                                    package_ids: package.id.to_s, role: 'student' }

            expect(response).to have_http_status(:unauthorized)
          end
        end
      end
    end

    describe 'when aiming to create a user platform admin' do
      context 'as admin' do
        before { user_platform_admin_session }
        context 'with valid params' do
          it 'return success and set user_platform role to admin' do
            platform = user_platform_admin.platform.freeze
            post :create, params: { email: user.email, password: 'teste123', role: 'admin' }

            user_platform = UserPlatform.where(user_id: user.id, platform_id: platform.id).take
            assert_jsonapi_response(:created, user_platform, UserPlatformSerializer, included)
            expect(user_platform.role).to eq('admin')
          end
        end
      end
    end
  end

  describe '#UPDATE' do
    context 'as admin' do
      before { user_platform_admin_session }
      let(:target_user_platform) do
        create(:user_platform, platform_id: user_platform_admin.platform.id)
      end
      let(:valid_attrs) { { role: 'admin', active: false, unity: "SP", options: { 'a' => 'b' } } }
      let(:unkown_up_token) { user_platform_admin.id + 500 }
      let(:invalid_attrs) { { role: false, unity: 1 } }
      context 'with valid params' do
        it 'update attributes' do
          post :update, params: { id: target_user_platform.token, role: 'teacher' }

          assert_jsonapi_response(:ok, target_user_platform.reload, UserPlatformSerializer)
          after_role = UserPlatform.find_by_token(target_user_platform.token).role
          expect(after_role).to eq('teacher')
        end
        it 'update attributes including platform_unity_id' do
          platform_unity_id_before = target_user_platform.platform_unity_id
          new_platform_unity_id = user_platform.platform_unity_id
          post :update,
               params: valid_attrs.merge(id: target_user_platform.token,
                                         platform_slug: user_platform.platform.slug,
                                         platform_unity_id: user_platform.platform_unity.id)

          assert_jsonapi_response(:ok, target_user_platform.reload, UserPlatformSerializer)
          platform_unity_id_after = UserPlatform.find_by_token(target_user_platform.token)
                                                .platform_unity_id
          expect(platform_unity_id_after).not_to eq(nil)
          expect(platform_unity_id_after).not_to eq(platform_unity_id_before)
          expect(platform_unity_id_after).to eq(new_platform_unity_id)
        end
      end

      context 'with invalid params' do
        context 'unknow user on platform' do
          it 'returns an error' do
            # post :update, params: invalid_attrs.merge(id: unkown_up_id)
            post :update, params: invalid_attrs.merge(id: unkown_up_token,
                                                      platform_slug: user_platform.platform.slug)

            expect(response).to have_http_status(:not_found)
          end
        end
        context 'incompatible type of fields' do
          it 'returns an error' do
            post :update, params: invalid_attrs.merge(id: target_user_platform.token,
                                                      platform_slug: user_platform.platform.slug)

            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end
    end

    context 'as simple user' do
      before { user_session }
      let(:user_platform_1) { create(:user_platform) }
      it 'returns unauthorized' do
        post :update, params: { id: user_platform_1.id }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe '#show' do
    context 'as admin' do
      before { user_platform_admin_session }
      let(:target_user_platform) do
        create(:user_platform, platform_id: user_platform_admin.platform.id)
      end
      let(:unkown_up_id) { user_platform_admin.id + 500 }
      let(:unkown_up_token) { 'Unkn0w' }

      context 'with existing id' do
        it 'return valid response' do
          get :show, params: { id: user_platform_admin.token }

          assert_apiv2_response(:ok, user_platform_admin, V3::UserPlatformSerializer)
        end
      end

      context 'invalid id' do
        it 'returns not found' do
          get :show, params: { id: unkown_up_token, platform_slug: user_platform.platform.slug }
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'as simple user' do
      before { user_session }
      it 'returns unauthorized status' do
        get :show, params: { id: 1 }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe '#DELETE' do
    describe 'as admin' do
      before { user_platform_admin_session }
      let(:user_platform_student) do
        create(:user_platform, platform: user_platform_admin.platform)
      end
      before do
        create(:access_with_expires_at,
               user_id: user_platform_student.user.id,
               platform_id: user_platform_student.platform.id,
               gift: true, active: true)
      end
      context 'with valid params' do
        it 'deactive user_platform and gifted access(soft delete)' do
          delete :destroy, params: {
            id: user_platform.token
          }

          expect(response).to have_http_status(:success)
          expect(UserPlatform.find(user_platform.id).active).to eq(false)
          expect(Access.where(user_id: user_platform.user_id,
                              platform_id: user_platform.platform_id, active: true).count).to eq(0)
        end
      end

      context 'with invalid params' do
        it 'returns an error' do
          delete :destroy, params: { id: 100 }

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe 'as user' do
      before { user_session }
      context 'with valid params' do
        let(:user_platform_1) { create(:user_platform) }
        it 'returns an error' do
          delete :destroy, params: { id: user_platform_1.token }

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
