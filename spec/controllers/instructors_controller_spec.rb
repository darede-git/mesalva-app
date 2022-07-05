# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InstructorsController, type: :controller do
  before { user_session }
  before do
    ENV['MESALVA_FOR_SCHOOLS_TEST_CAMPAIGN_ACTIVE'] = 'true'
    ENV['MESALVA_FOR_SCHOOLS_PACKAGE_ID'] = package.id.to_s
    ENV['MESALVA_FOR_SCHOOLS_PACKAGE_INTERVAL_IN_DAYS'] = '1'
  end
  let(:package) { create(:package_valid_with_price) }

  context '#create' do
    context 'user is not an instructor yet' do
      it 'creates a instructor for the current user' do
        expect { post :create }.to change(Instructor, :count).by(1)
      end
      it 'creates access for the current user' do
        expect { post :create }.to change(Access, :count).by(1)
      end
    end
    context 'user is already instructor yet' do
      before do
        create(:instructor, user_id: user.id)
      end

      it 'gives error message with already instructor' do
        post :create

        expect(parsed_response['errors']).not_to be_empty
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context '#is_instructor' do
    context 'user is instructor' do
      before do
        create(:instructor, user_id: user.id)
      end

      it 'renders true if current user is instructor' do
        get :is_instructor
      end
    end
    context 'user is not instructor' do
      it 'renders no content' do
        get :is_instructor
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  context '#students' do
    let!(:instructor) { create(:instructor, user_id: user.id) }
    let!(:user1)  { create(:user) }
    let!(:user2)  { create(:user) }

    before do
      instructor.users << user1
      instructor.users << user2
    end

    it 'returns all students under a instructor' do
      get :students

      expect(parsed_response.to_s).to include(user1.uid)
      expect(parsed_response.to_s).to include(user2.uid)
    end
  end

  context '#student_watched_and_read_material' do
    let!(:instructor) { create(:instructor, user_id: user.id) }
    let!(:user1) { create(:user) }
    let!(:item) { create(:item) }

    before do
      instructor.users << user1
      create(:permalink_event,
             user_id: user1.id,
             id: 88_000_001,
             permalink_item_id: item.id,
             event_name: 'lesson_watch')
      create(:permalink_event,
             user_id: user1.id,
             id: 88_000_002,
             permalink_medium_type: 'text',
             permalink_item_id: item.id,
             event_name: 'text_read')
    end
    it 'returns all material consumed by the student' do
      get :student_watched_and_read_material, params: { student_uid: user1.uid }

      expect(parsed_response.first).not_to be_nil
    end
  end

  context '#student_exercises' do
    let!(:instructor) { create(:instructor, user_id: user.id) }
    let!(:user1) { create(:user) }
    let!(:node_module) { create(:node_module) }

    before do
      instructor.users << user1
      create(:permalink_event_answer,
             user_id: user1.id,
             id: 88_000_001,
             permalink_node_slug: ['enem-e-vestibulares'],
             permalink_node_module_id: node_module.id)
    end

    it 'returns the users answer by module' do
      get :student_exercises, params: { student_uid: user1.uid }

      expect(parsed_response).not_to be_empty
    end
  end

  context '#student' do
    let!(:instructor) { create(:instructor, user_id: user.id) }
    let!(:user1) { create(:user) }

    before do
      create(:permalink_event, user_id: user1.id, id: 88_000_001)
      create(:permalink_event,
             user_id: user1.id,
             id: 88_000_002,
             permalink_item_type: 'text')
    end
    context 'student is not under instructor' do
      it 'does not return student' do
        get :student, params: { student_uid: user1.uid }

        expect(parsed_response['errors']).not_to be_empty
      end
    end

    context 'student is under instructor' do
      before do
        instructor.users << user1
      end

      it 'returns consumption of student' do
        get :student, params: { student_uid: user1.uid }

        expect(parsed_response.first['type']).to eq('text')
        expect(parsed_response.first['count']).to eq(1)
        expect(parsed_response.second['type']).to eq('video')
        expect(parsed_response.second['count']).to eq(1)
      end
    end
  end
end
