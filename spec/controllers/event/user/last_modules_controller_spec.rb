# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event::User::LastModulesController, type: :controller do
  include PermalinkAssertionHelper
  include PermalinkEventAssertionHelper

  include_context 'permalink building'

  let(:full_user_session) do
    user_session
    add_custom_headers(event_data_headers)
  end

  let(:event_data_headers) do
    JSON.parse(File.read('spec/fixtures/event_data_headers.json'))
  end

  before do
    ENV['PAGINATION_SIZE'] = '10'
  end
  describe 'GET #show' do
    context 'user is present' do
      context 'with filter' do
        context 'filtering by education segment' do
          before do
            full_user_session
            mock_user_consumed_modules_cache(user_consumed_modules_double)
            mock_user_consumed_media_cache(user_consumed_media_double)
          end
          it 'filters the results before pagination' do
            {
              'concursos': 1, 'engenharia': 3, 'enem-e-vestibulares': 1
            }.each do |filter, results|
              get :show, params: { education_segment: filter }

              expect(response.headers['Total']).to eq results.to_s
              expect(parsed_response['results'].count).to eq results
              expect(response.headers['Link']).to be_nil
            end
          end
        end
      end
      context 'without filter' do
        before do
          full_user_session
          allow_any_instance_of(MeSalva::Event::User::LastModulesCache)
            .to receive(:cache).and_return(
              user_last_modules_double +
              user_last_modules_double +
              user_last_modules_double
            )
        end
        after do
          expect(response.headers['Per-Page']).to eq "10"
        end
        context 'multiple pages' do
          after do
            expect(response.headers['Total']).to eq "15"
          end
          it 'paginates the result with 10 per_page' do
            get :show

            expect(parsed_response['results'].count).to eq 10
            expect(response.headers['Link']).to \
              eq '<http://test.host/events/user/last_modules?page=2>; '\
              'rel="last", '\
              '<http://test.host/events/user/last_modules?page=2>; '\
              'rel="next"'
          end
          context 'viewing second page' do
            context 'second page has results' do
              it 'returns correct page result' do
                get :show, params: { page: 2 }

                expect(parsed_response['results'].count).to eq 5
                expect(response.headers['Link']).to \
                  eq '<http://test.host/events/user/last_modules?page=1>; '\
                  'rel="first", '\
                  '<http://test.host/events/user/last_modules?page=1>; '\
                  'rel="prev"'
              end
            end
          end
        end
        context 'second page has no results' do
          before do
            allow_any_instance_of(MeSalva::Event::User::LastModulesCache)
              .to receive(:cache).and_return(user_last_modules_double)
          end
          context 'viewing last page' do
            it 'returns correct page result' do
              get :show

              expect(response.headers['Total']).to eq "5"
              expect(parsed_response['results'].count).to eq 5
              expect(response.headers['Link']).to be_nil
            end
          end
          context 'viewing empty page' do
            it 'returns correct page result' do
              get :show, params: { page: 2 }

              expect(response.headers['Total']).to eq "5"
              expect(parsed_response['results'].count).to eq 0
              expect(response.headers['Link']).to \
                eq '<http://test.host/events/user/last_modules?page=1>; '\
                'rel="first", '\
                '<http://test.host/events/user/last_modules?page=1>; '\
                'rel="prev"'
            end
          end
        end
      end
    end
  end
end
