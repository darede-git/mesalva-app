# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MentoringsController, type: :controller do
  let(:default_serializer) { V2::MentoringSerializer }
  describe "mentoring" do
    context '#index' do
      before { user_session }
      let!(:mentor) do
        create(:mentoring)
      end
      it 'returns a mentoring' do
        get :index
        assert_apiv2_response(:ok, [mentor], default_serializer)
      end
    end
    context '#create' do
      before { admin_session }
      let!(:usuario) do
        create(:user)
      end
      let!(:teacher) do
        create(:content_teacher)
      end
      let(:valid_mentoring) do
        FactoryBot.attributes_for(:mentoring, user_id: usuario.id, content_teacher_id: teacher.id)
      end
      it 'creates a new mentoring' do
        post :create, params: valid_mentoring
        assert_apiv2_response(:created, Mentoring.last, default_serializer)
      end
    end

    context '#update' do
      before { admin_session }
      let!(:mentor) do
        create(:mentoring)
      end
      it 'returns a serializad mentoring json' do
        post :update, params: {
          id: mentor.id,
          title: 'new example title',
          status: 2,
          comment: 'new example comment',
          starts_at: Time.now,
          simplybook_id: 1
        }
        assert_apiv2_response(:ok, mentor.reload, default_serializer)
      end
    end

    context '#show' do
      before { admin_session }
      let!(:mentor) do
        create(:mentoring)
      end
      it ' select the requested mentoring' do
        get :show, params: { id: mentor.id }
        assert_apiv2_response(:ok, mentor, default_serializer)
      end
    end

    context '#destroy' do
      before { admin_session }
      let!(:mentor) do
        create(:mentoring)
      end
      it 'destroy the requested mentoring' do
        expect do
          delete :destroy, params: { id: mentor.id }
        end.to change(Mentoring, :count).by(-1)
      end
    end
  end
end
