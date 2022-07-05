# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/crm/users'

RSpec.describe CrmEventsController, type: :controller do
  include CrmEventAssertionHelper

  subject { MeSalva::Crm::Events.new }
  let(:client) { double }
  let(:package) { create(:package_valid_with_price) }
  let(:example_campaign) { 'example-campaign' }
  let(:valid_attributes) { { package_id: package.id } }

  let(:event_data_headers) do
    JSON.parse(File.read('spec/fixtures/event_data_headers.json'))
  end

  describe 'POST create' do
    before do
      mock_intercom_event
      user.current_sign_in_ip = "0.0.0.0"
      Timecop.freeze(Time.now)
    end
    context 'as user' do
      context 'with valid attributes' do
        before { create(:node, name: 'engenharia') }
        context 'for checkout_view event' do
          let(:checkout_view_event_name) { 'checkout_view' }
          let(:checkout_view_attributes) do
            { cf_package_name: package.name,
              cf_package_slug: package.slug,
              cf_package_duration: package.duration.to_s,
              cf_package_sku: package.sku }
          end
          let(:checkout_view_valid_attributes) { { package_id: package.id } }
          before do
            expect_checkout_view_rd_station(checkout_view_event_name,
                                            package,
                                            checkout_view_attributes)
          end

          it 'creates a new checkout_view event' do
            full_user_session('checkout_view')
            expect(ChatGuruWorker).to receive(:perform_in)
            expect do
              post :create, params: checkout_view_valid_attributes
            end.to change(CrmEvent, :count).by(1)

            expect(response).to have_http_status(:no_content)
            assert_last_crm_event_values(checkout_view_event_name,
                                         user,
                                         package: package,
                                         custom_headers: event_data_headers)
          end
        end

        it 'creates a new plans view event' do
          full_user_session('plans_view')
          expect do
            post :create, params: { education_segment_slug: 'engenharia' }
          end.to change(CrmEvent, :count).by(1)

          expect(response).to have_http_status(:no_content)
          assert_last_crm_event_values('plans_view', user,
                                       education_segment_slug: 'engenharia',
                                       custom_headers: event_data_headers)
        end

        it 'creates a new checkout fail event' do
          full_user_session('checkout_fail')
          expect do
            post :create, params: { education_segment_slug: 'engenharia',
                                    package_id: package.id }
          end.to change(CrmEvent, :count).by(1)

          expect(response).to have_http_status(:no_content)
          assert_last_crm_event_values('checkout_fail', user,
                                       education_segment_slug: 'engenharia',
                                       package: package,
                                       custom_headers: event_data_headers)
        end

        it 'creates a new campaign view event' do
          full_user_session('campaign_view')
          expect(UpdateIntercomUserWorker).to receive(:perform_async)

          expect do
            post :create, params: { campaign_name: 'maratona_2017_1' }
          end.to change(CrmEvent, :count).by(1)

          expect(response).to have_http_status(:no_content)
          assert_last_crm_event_values('campaign_view', user,
                                       custom_headers: event_data_headers,
                                       campaign_name: 'maratona_2017_1')
        end

        context 'for campaign_sign_up event' do
          let(:campaign_sign_up_event_name) { 'campaign_sign_up' }
          let(:campaign_sign_up_attributes) { { cf_campaign_view_name: example_campaign } }
          let(:campaign_sign_up_valid_attributes) { { campaign_name: example_campaign } }
          before do
            expect_campaign_sign_up_rd_station(campaign_sign_up_event_name,
                                               example_campaign,
                                               campaign_sign_up_attributes)
          end

          it 'creates a new campaign_sign_up event' do
            full_user_session(campaign_sign_up_event_name)
            expect do
              post :create, params: campaign_sign_up_valid_attributes
            end.to change(CrmEvent, :count).by(1)

            expect(response).to have_http_status(:no_content)
            assert_last_crm_event_values('campaign_sign_up',
                                         user,
                                         custom_headers: event_data_headers,
                                         campaign_name: example_campaign)
          end
        end
      end

      context 'with invalid attributes' do
        it 'returns unprocessable_entity status' do
          full_user_session('checkout_view')
          expect { post :create }.to change(Order, :count).by(0)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'without authentication' do
      it_behaves_like 'an unauthorized status' do
        let(:model) { CrmEvent }
      end
    end
  end

  def full_user_session(event_name)
    user_session.merge(
      add_custom_headers(event_data_headers.merge('event-name' => event_name))
    )
  end

  def expect_checkout_view_rd_station(event_name, package, attributes)
    client = double
    expect(MeSalva::Crm::Rdstation::Event::Client).to receive(:new)
      .with({ user: user,
              event_name: "#{event_name}|#{package.sku}",
              payload: attributes })
      .and_return(client)
    expect(client).to receive(:create)
  end

  def expect_campaign_sign_up_rd_station(event_name, campaign_name, attributes)
    client = double
    expect(MeSalva::Crm::Rdstation::Event::Client).to receive(:new)
      .with({ user: user,
              event_name: "#{event_name}|#{campaign_name}",
              payload: attributes })
      .and_return(client)
    expect(client).to receive(:create)
  end
end
