# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CampaignEventsController, type: :controller do
  include ContentStructureAssertionHelper

  let(:inviter_user) { create(:user) }
  describe 'POST #create' do
    context 'as user' do
      before { user_session }
      let(:campaign_name) { 'example-campaign-name' }
      let(:event_name) { 'example-event-name' }
      let(:invalid_token) { 'ti68bndfbdd64362984j' }
      context 'with valid params' do
        it 'creates a new Campaign Event record' do
          @request.headers[:utm_content] = inviter_user.token
          expect do
            post :create, params: { utm_content: inviter_user.token,
                                    campaign_name: campaign_name,
                                    event_name: event_name }
          end.to change(CampaignEvent, :count).by(1)
          assert_jsonapi_response(:created, CampaignEvent.last, CampaignEventSerializer)
          attrs_response = parsed_response['data']['attributes']
          expect(attrs_response['campaign-name']).to eq(campaign_name)
          expect(attrs_response['event-name']).to eq(event_name)
        end
      end
      context 'with invalid user token' do
        it 'returns http unprocessable_entity' do
          @request.headers[:utm_content] = invalid_token
          post :create, params: { campaign_name: campaign_name,
                                  event_name: event_name }
          assert_type_and_status(:unprocessable_entity)
        end
      end
    end
    context 'not logged' do
      let(:campaign_name) { 'example-campaign-name' }
      let(:event_name) { 'example-event-name' }
      it 'returns http unauthorized' do
        @request.headers[:utm_content] = user.token
        post :create, params: { campaign_name: campaign_name,
                                event_name: event_name }
        assert_type_and_status(:unauthorized)
      end
    end
  end

  describe 'GET #show_event' do
    context 'as user' do
      before { user_session }
      context 'gets valid user/campaign/event' do
        context 'that created the event' do
          let!(:campaign_event) do
            create(:campaign_event, :first_event, user: user)
          end
          it 'returns right signed user campaign_event' do
            get :show_event, params: { campaign_name: campaign_event.campaign_name,
                                       event_name: campaign_event.event_name }
            expect(parsed_response["results"]["campaign_name"]).to eq(campaign_event.campaign_name)
            expect(parsed_response["results"]["event_name"]).to eq(campaign_event.event_name)
            assert_type_and_status(:ok)
          end
        end
        context 'that not created the event' do
          let!(:campaign_event2) do
            create(:campaign_event, :second_event, user_id: user.id + 1)
          end
          it 'returns right signed user campaign_event' do
            get :show_event, params: { campaign_name: campaign_event2.campaign_name,
                                       event_name: campaign_event2.event_name }
            assert_type_and_status(:not_found)
          end
        end
      end
    end
  end

  describe 'GET #count_sequence' do
    context 'as user' do
      before { user_session }
      let(:campaign_name) { 'campaign-example' }
      let(:event_name_1) { 'event-sign-up' }
      let(:event_name_2) { 'event-simulado' }
      context 'with existing user, campaign and event' do
        context 'gets three invitations where one of them had the mock done' do
          let!(:campaign_event_event1_user1) do
            create(:campaign_event,
                   :first_event,
                   invited_by: user.id)
          end
          let!(:campaign_event_event1_user2) do
            create(:campaign_event,
                   :first_event,
                   invited_by: user.id)
          end
          let!(:campaign_event_event1_user3) do
            create(:campaign_event,
                   :first_event,
                   invited_by: user.id)
          end
          let!(:campaign_event_event2_user1) do
            create(:campaign_event,
                   :second_event,
                   user_id: campaign_event_event1_user1.user_id,
                   invited_by: user.id)
          end
          it 'returns the invitations sent and the mocks done' do
            get :count_sequence, params: { campaign_name: campaign_name,
                                           event1: event_name_1,
                                           event2: event_name_2 }
            expect(parsed_response['results']).to eq({ "event_1_count" => 3,
                                                       "event_2_count" => 1 })
            assert_type_and_status(:ok)
          end
        end
        context 'gets two invitations where none of them had the mock done' do
          let!(:campaign_event_event1_user1) do
            create(:campaign_event,
                   :first_event,
                   invited_by: user.id)
          end
          let!(:campaign_event_event1_user2) do
            create(:campaign_event,
                   :first_event,
                   invited_by: user.id)
          end
          it 'returns the invitations sent and the mocks done' do
            get :count_sequence, params: { campaign_name: campaign_name,
                                           event1: event_name_1,
                                           event2: event_name_2 }
            expect(parsed_response['results']).to eq({ "event_1_count" => 2,
                                                       "event_2_count" => 0 })
            assert_type_and_status(:ok)
          end
        end
        context 'gets zero invitations with a mock done' do
          let!(:campaign_event_event2_user1) do
            create(:campaign_event,
                   :second_event,
                   invited_by: user.id)
          end
          it 'should returns zero records' do
            get :count_sequence, params: { campaign_name: campaign_name,
                                           event1: event_name_1,
                                           event2: event_name_2 }
            expect(parsed_response['results']).to eq({ "event_1_count" => 0,
                                                       "event_2_count" => 0 })
            assert_type_and_status(:ok)
          end
        end
      end
      context 'with a nonexistent inviter' do
        it 'returns zero invites' do
          get :count_sequence, params: { campaign_name: campaign_name,
                                         event1: event_name_1,
                                         event2: event_name_2 }
          expect(parsed_response['results']).to eq({ "event_1_count" => 0,
                                                     "event_2_count" => 0 })
          assert_type_and_status(:ok)
        end
      end
      context 'with a nonexistent campaign' do
        it 'returns zero invites' do
          get :count_sequence, params: { campaign_name: 'fake-campaign',
                                         event1: event_name_1,
                                         event2: event_name_2 }
          expect(parsed_response['results']).to eq({ "event_1_count" => 0,
                                                     "event_2_count" => 0 })
          assert_type_and_status(:ok)
        end
      end
      context 'with a nonexistent event' do
        it 'returns zero invites' do
          get :count_sequence, params: { campaign_name: campaign_name,
                                         event1: 'fake-event',
                                         event2: event_name_2 }
          expect(parsed_response['results']).to eq({ "event_1_count" => 0,
                                                     "event_2_count" => 0 })
          assert_type_and_status(:ok)
        end
      end
    end
    context 'not logged' do
      it 'returns http unauthorized' do
        get :count_sequence, params: { event1: '',
                                       event2: '' }
        assert_type_and_status(:unauthorized)
      end
    end
  end
end
