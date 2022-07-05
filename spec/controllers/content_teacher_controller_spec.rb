# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContentTeachersController, type: :controller do
  include FixturesHelper

  let(:default_serializer) { V3::ContentTeacherSerializer }

  describe "content_teacher" do
    include PermissionHelper

    context '#index' do
      before { user_session }
      before { grant_test_permission('index') }

      context 'without permission' do
        let!(:first_teacher) { create(:content_teacher) }
        it 'returns a content_teacher' do
          get :index
          assert_apiv2_response(:ok, [first_teacher], default_serializer)
        end
      end
    end

    context '#create' do
      context 'as user' do
        before { user_session }
        context 'with permission' do
          before { grant_test_permission('create') }
          let(:create_params) do
            { name: 'Example name',
              slug: 'Example slug',
              image: Rack::Test::UploadedFile.new(File.join(Rails.root,
                                                            'spec',
                                                            'support',
                                                            'uploaders',
                                                            'mesalva.png')),
              avatar: Rack::Test::UploadedFile.new(File.join(Rails.root,
                                                             'spec',
                                                             'support',
                                                             'uploaders',
                                                             'mesalva.png')),
              description: 'Example description',
              content_type: 'Example type' }
          end
          it 'creates a new content_teacher' do
            post :create, params: create_params
            assert_apiv2_response(:created, ContentTeacher.last, default_serializer)
          end
        end
      end
    end

    context '#update' do
      context 'as user' do
        before { user_session }
        context 'with permission' do
          before { grant_test_permission('update') }
          let(:updateTeacher) do
            create(:content_teacher)
          end
          it 'returns a serializad content_teacher json' do
            put :update, params: { slug: updateTeacher.slug,
                                   name: 'new_name',
                                   image: default_test_image,
                                   avatar: default_test_image,
                                   description: 'new_description',
                                   content_type: 'new_type' }
            assert_apiv2_response(:ok, updateTeacher.reload, default_serializer)
          end
        end
      end
    end

    context '#show' do
      context 'without permission' do
        let(:showTeacher) do
          create(:content_teacher)
        end
        it 'creates a content_teacher with a custom slug' do
          get :show, params: { slug: showTeacher.slug }
          assert_apiv2_response(:ok, showTeacher, default_serializer)
        end
      end
    end

    context '#destroy' do
      context 'as user' do
        before { user_session }
        context 'with permission' do
          before { grant_test_permission('destroy') }
          let!(:destroyTeacher) { create(:content_teacher) }
          it 'destroy a content_teacher with a custom slug' do
            delete :destroy, params: { slug: destroyTeacher.slug }

            expect(response).to have_http_status(:no_content)
            expect(destroyTeacher.reload.active).to eq(false)
          end
        end
      end
    end
  end
end
