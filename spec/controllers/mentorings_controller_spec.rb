# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MentoringsController, type: :controller do
  include PermissionHelper
  let(:default_serializer) { V2::MentoringSerializer }
  describe "mentoring" do
    context "with user session" do
      before { user_session }

      context '#index' do
        before { grant_test_permission('index') }

        context "with mentorings" do
          let!(:mentorings) do
            [
              create(:mentoring, :private_class_chemistry_yesterday),
              create(:mentoring, :mentoring_math_tomorrow)
            ]
          end
          context "without any filter" do
            it 'returns all mentorings' do
              get :index
              assert_apiv2_response(:ok, mentorings, default_serializer)
            end
            context "with order by param" do
              it 'returns all mentorings' do
                get :index, params: { order_by: 'starts_at DESC' }
                assert_apiv2_response(:ok, mentorings.reverse, default_serializer)
              end
            end
          end

          context "with active filter" do
            it 'returns only active mentorings' do
              get :index, params: { active: true }
              assert_apiv2_response(:ok, [mentorings[0]], default_serializer)
            end
            it 'returns only canceled mentorings' do
              get :index, params: { active: false }
              assert_apiv2_response(:ok, [mentorings[1]], default_serializer)
            end
          end

          context "with user filter" do
            it 'returns only user by uid mentorings' do
              get :index, params: { user_uid: mentorings[0].user.uid }
              assert_apiv2_response(:ok, [mentorings[0]], default_serializer)
            end
          end

          context "with teacher filter" do
            it 'returns only teacher email mentorings' do
              get :index, params: { like_content_teacher_name: mentorings[1].content_teacher.name }
              assert_apiv2_response(:ok, [mentorings[1]], default_serializer)
            end
            it 'returns only teacher id mentorings' do
              get :index, params: { content_teacher_id: mentorings[1].content_teacher_id }
              assert_apiv2_response(:ok, [mentorings[1]], default_serializer)
            end
          end

          context "with next_only filter" do
            it 'returns only next mentorings' do
              get :index, params: { next_only: true }
              assert_apiv2_response(:ok, [mentorings[1]], default_serializer)
            end
          end

          context "with title filter" do
            it 'returns only "matemática" mentorings' do
              get :index, params: { like_title: 'matemática' }
              assert_apiv2_response(:ok, [mentorings[1]], default_serializer)
            end
          end

          context "with category filter" do
            it 'returns only "mentoring category" mentorings' do
              get :index, params: { category: 'private_class' }
              assert_apiv2_response(:ok, [mentorings[0]], default_serializer)
            end
          end
        end
      end

      context '#create' do
        before { grant_test_permission('create') }
        let!(:student) { create(:user) }
        let!(:teacher) { create(:content_teacher, email: 'some-teacher@email.com') }

        it 'creates a new mentoring' do
          post :create, params: { user_uid: student.uid, content_teacher_email: teacher.email,
                                  active: true, starts_at: DateTime.now + 1.day }
          assert_apiv2_response(:created, Mentoring.last, default_serializer)
        end
      end

      context '#update' do
        before { grant_test_permission('update') }
        let!(:mentoring) { create(:mentoring) }
        it 'returns a serializad mentoring json' do
          post :update, params: {
            id: mentoring.id,
            title: 'new example title',
            active: true,
            starts_at: Time.now + 1.day
          }
          assert_apiv2_response(:ok, mentoring.reload, default_serializer)
        end
      end

      context '#show' do
        before { grant_test_permission('show') }
        let!(:mentoring) { create(:mentoring) }
        it ' select the requested mentoring' do
          get :show, params: { id: mentoring.id }
          assert_apiv2_response(:ok, mentoring, default_serializer)
        end
      end

      context '#destroy' do
        before { grant_test_permission('destroy') }
        let!(:mentoring) do
          create(:mentoring)
        end
        it 'destroy the requested mentoring' do
          delete :destroy, params: { id: mentoring.id }
          expect(mentoring.reload.active).to eq(false)
        end
      end
    end
  end
end
