# frozen_string_literal: true

require 'me_salva/schedules/client'
require 'rails_helper'

RSpec.describe MeSalva::Schedules::Bookings do
  include SimplybookAssertionHelper
  include FixturesHelper

  let(:client) { described_class.new }
  context '#sync_next_bookings' do
    context 'with a valid fake token' do
      let(:token) { { 'token' => 'token_test' } }
      let!(:bookings) { json_fixture("simplybook/event_list_all") }

      context 'for two simplybook api responses' do
        context 'valid users and content teachers' do
          let!(:users) do
            {
              'user1@mesalva.com': create(:user,
                                          crm_email: 'user1@mesalva.com'),
              'user2@mesalva.com': create(:user,
                                          crm_email: 'user2@mesalva.com')
            }
          end
          let!(:teachers) do
            {
              'contentteacher1@mesalva.com': create(:content_teacher,
                                                    email: 'contentteacher1@mesalva.com'),
              'contentteacher2@mesalva.com': create(:content_teacher,
                                                    email: 'contentteacher2@mesalva.com')
            }
          end

          context 'and valid fake simplybook data' do
            before do
              connect_simplybook
              mock_bookings_requests
            end
            it 'synchronizes the simplybook data with our database' do
              mentorings = client.sync_next_bookings

              mentorings.each do |mentoring|
                event = bookings.find { |e| mentoring.simplybook_id == e['id'] }
                expect(mentoring.title).to eq(event['service']['name'])
                expect(mentoring.status).to eq(event['status'])
                expect(mentoring.starts_at).to eq(event['start_datetime'])
                expect(mentoring.user.crm_email).to eq(event['client']['email'])
                expect(mentoring.content_teacher.email).to eq(event['provider']['email'])
              end
            end
          end
        end
      end
    end
  end

  def mock_bookings_requests
    mock_bookings_indexes
    mock_bookings_shows
  end

  def simplybook_api
    'https://user-api-v2.simplybook.me/admin'
  end

  def mock_bookings_indexes
    total_mock_pages = 2
    total_mock_pages.times do |index|
      allow(HTTParty).to receive(:get)
        .with("#{simplybook_api}/bookings?filter[upcoming_only]=1&page=#{index + 1}",
              headers: { 'Content-Type': 'application/json',
                         'X-Company-Login': ENV['SIMPLYBOOK_COMPANY_LOGIN'],
                         'X-Token': token['token'] })
        .and_return(http_party_200_response(json_fixture("simplybook/event_list_#{index + 1}")))
    end
  end

  def mock_bookings_shows
    valid_bookings = 3
    valid_bookings.times do |index|
      allow(HTTParty).to receive(:get)
        .with("#{simplybook_api}/bookings/#{index + 1}",
              headers: { 'Content-Type': 'application/json',
                         'X-Company-Login': ENV['SIMPLYBOOK_COMPANY_LOGIN'],
                         'X-Token': token['token'] })
        .and_return(http_party_200_response(json_fixture("simplybook/event_show_#{index + 1}")))
    end
  end
end
