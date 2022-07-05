# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShortenerUrlsController, type: :controller do
  describe 'POST #create' do
    context 'with user session' do
      before { user_session }
      context 'with a complete URL' do
        context 'with SSL' do
          context 'with a new URL' do
            let(:url) { 'https://www.mesalva.com/example' }
            context 'with a generated key' do
              let(:valid_params) { { url: url } }
              it 'creates and returns a new record of URL with a generated key' do
                expect do
                  post :create, params: valid_params
                end.to change(Shortener::ShortenedUrl, :count).by(1)
                record_created = Shortener::ShortenedUrl.last
                expect(response).to have_http_status(:ok)
                expect(parsed_response['shortened_url']).not_to eq(nil)
                expect(record_created['unique_key']).not_to eq(nil)
                expect(record_created['url']).to eq(url)
              end
            end
            context 'with a custom key' do
              let(:custom_key) { 'h5kd97uhg6' }
              let(:valid_params) { { url: url, token: custom_key } }
              it 'creates and returns a new record of URL with a custom key' do
                expect do
                  post :create, params: valid_params
                end.to change(Shortener::ShortenedUrl, :count).by(1)
                record_created = Shortener::ShortenedUrl.last
                expect(response).to have_http_status(:ok)
                expect(parsed_response['shortened_url'].split('/').last).to eq(custom_key)
                expect(record_created['unique_key']).to eq(custom_key)
                expect(record_created['url']).to eq(url)
              end
            end
          end
          context 'with an existent URL' do
            let(:url) { 'https://www.mesalva.com/example' }
            context 'with a generated key' do
              let(:valid_params) { { url: url } }
              it 'finds and returns a record of URL with a generated key' do
                shortened_url_existent = Shortener::ShortenedUrl.generate(url, owner: user)
                expect do
                  post :create, params: valid_params
                end.to change(Shortener::ShortenedUrl, :count).by(0)
                expect(response).to have_http_status(:ok)
                expect(parsed_response['shortened_url'].split('/').last).to \
                  eq(shortened_url_existent.unique_key)
              end
            end
            context 'with a custom key' do
              let(:custom_key_existent) { 'h5kd97uhg6' }
              let(:valid_params) { { url: url, custom_key: custom_key_existent } }
              it 'finds and returns a record of URL with a custom key' do
                Shortener::ShortenedUrl.generate(url, owner: user, custom_key: custom_key_existent)
                expect do
                  post :create, params: valid_params
                end.to change(Shortener::ShortenedUrl, :count).by(0)
                expect(response).to have_http_status(:ok)
                expect(parsed_response['shortened_url'].split('/').last).to eq(custom_key_existent)
              end
            end
          end
        end
        context 'without SSL' do
          context 'with a new URL' do
            let(:url) { 'http://www.mesalva.com/example' }
            context 'with a generated key' do
              let(:valid_params) { { url: url } }
              it 'creates and returns a new record of URL with a generated key' do
                expect do
                  post :create, params: valid_params
                end.to change(Shortener::ShortenedUrl, :count).by(1)
                record_created = Shortener::ShortenedUrl.last
                expect(response).to have_http_status(:ok)
                expect(parsed_response['shortened_url']).not_to eq(nil)
                expect(record_created['unique_key']).not_to eq(nil)
                expect(record_created['url']).to eq(url.sub('http:', 'https:'))
              end
            end
            context 'with a custom key' do
              let(:custom_key) { 'h5kd97uhg6' }
              let(:valid_params) { { url: url, token: custom_key } }
              it 'creates and returns a new record of URL with a custom key' do
                expect do
                  post :create, params: valid_params
                end.to change(Shortener::ShortenedUrl, :count).by(1)
                record_created = Shortener::ShortenedUrl.last
                expect(response).to have_http_status(:ok)
                expect(parsed_response['shortened_url'].split('/').last).to eq(custom_key)
                expect(record_created['unique_key']).to eq(custom_key)
                expect(record_created['url']).to eq(url.sub('http:', 'https:'))
              end
            end
          end
          context 'with an existent URL' do
            let(:url) { 'http://www.mesalva.com/example' }
            context 'with a generated key' do
              let(:valid_params) { { url: url } }
              it 'finds and returns a record of URL with a generated key' do
                shortened_url_existent =
                  Shortener::ShortenedUrl.generate(url.sub('http:', 'https:'),
                                                   owner: user)
                expect do
                  post :create, params: valid_params
                end.to change(Shortener::ShortenedUrl, :count).by(0)
                expect(response).to have_http_status(:ok)
                expect(parsed_response['shortened_url'].split('/').last).to \
                  eq(shortened_url_existent.unique_key)
              end
            end
            context 'with a custom key' do
              let(:custom_key_existent) { 'h5kd97uhg6' }
              let(:valid_params) { { url: url, custom_key: custom_key_existent } }
              it 'finds and returns a record of URL with a custom key' do
                Shortener::ShortenedUrl.generate(url.sub('http:', 'https:'),
                                                 owner: user,
                                                 custom_key: custom_key_existent)
                expect do
                  post :create, params: valid_params
                end.to change(Shortener::ShortenedUrl, :count).by(0)
                expect(response).to have_http_status(:ok)
                expect(parsed_response['shortened_url'].split('/').last).to eq(custom_key_existent)
              end
            end
          end
        end
      end
      context 'with an incomplete URL' do
        context 'with URL starting with /' do
          context 'with a new URL' do
            let(:url) { '/example' }
            context 'with a generated key' do
              let(:valid_params) { { url: url } }
              it 'creates and returns a new record of URL with a generated key' do
                expect do
                  post :create, params: valid_params
                end.to change(Shortener::ShortenedUrl, :count).by(1)
                record_created = Shortener::ShortenedUrl.last
                expect(response).to have_http_status(:ok)
                expect(parsed_response['shortened_url']).not_to eq(nil)
                expect(record_created['unique_key']).not_to eq(nil)
                expect(record_created['url']).to eq("https://www.mesalva.com#{url}")
              end
            end
            context 'with a custom key' do
              let(:custom_key) { 'h5kd97uhg6' }
              let(:valid_params) { { url: url, token: custom_key } }
              it 'creates and returns a new record of URL with a custom key' do
                expect do
                  post :create, params: valid_params
                end.to change(Shortener::ShortenedUrl, :count).by(1)
                record_created = Shortener::ShortenedUrl.last
                expect(response).to have_http_status(:ok)
                expect(parsed_response['shortened_url'].split('/').last).to eq(custom_key)
                expect(record_created['unique_key']).to eq(custom_key)
                expect(record_created['url']).to eq("https://www.mesalva.com#{url}")
              end
            end
          end
          context 'with an existent URL' do
            let(:url) { '/example' }
            context 'with a generated key' do
              let(:valid_params) { { url: url } }
              it 'finds and returns a record of URL with a generated key' do
                shortened_url_existent =
                  Shortener::ShortenedUrl.generate("https://www.mesalva.com#{url}",
                                                   owner: user)
                expect do
                  post :create, params: valid_params
                end.to change(Shortener::ShortenedUrl, :count).by(0)
                expect(response).to have_http_status(:ok)
                expect(parsed_response['shortened_url'].split('/').last).to \
                  eq(shortened_url_existent.unique_key)
              end
            end
            context 'with a custom key' do
              let(:custom_key_existent) { 'h5kd97uhg6' }
              let(:valid_params) { { url: url, custom_key: custom_key_existent } }
              it 'finds and returns a record of URL with a custom key' do
                Shortener::ShortenedUrl.generate("https://www.mesalva.com#{url}",
                                                 owner: user,
                                                 custom_key: custom_key_existent)
                expect do
                  post :create, params: valid_params
                end.to change(Shortener::ShortenedUrl, :count).by(0)
                expect(response).to have_http_status(:ok)
                expect(parsed_response['shortened_url'].split('/').last).to eq(custom_key_existent)
              end
            end
          end
        end
        context 'with URL not starting with /' do
          context 'with a new URL' do
            let(:url) { 'example' }
            context 'with a generated key' do
              let(:valid_params) { { url: url } }
              it 'creates and returns a new record of URL with a generated key' do
                expect do
                  post :create, params: valid_params
                end.to change(Shortener::ShortenedUrl, :count).by(1)
                record_created = Shortener::ShortenedUrl.last
                expect(response).to have_http_status(:ok)
                expect(parsed_response['shortened_url']).not_to eq(nil)
                expect(record_created['unique_key']).not_to eq(nil)
                expect(record_created['url']).to eq("https://www.mesalva.com/#{url}")
              end
            end
            context 'with a custom key' do
              let(:custom_key) { 'h5kd97uhg6' }
              let(:valid_params) { { url: url, token: custom_key } }
              it 'creates and returns a new record of URL with a custom key' do
                expect do
                  post :create, params: valid_params
                end.to change(Shortener::ShortenedUrl, :count).by(1)
                record_created = Shortener::ShortenedUrl.last
                expect(response).to have_http_status(:ok)
                expect(parsed_response['shortened_url'].split('/').last).to eq(custom_key)
                expect(record_created['unique_key']).to eq(custom_key)
                expect(record_created['url']).to eq("https://www.mesalva.com/#{url}")
              end
            end
          end
          context 'with an existent URL' do
            let(:url) { 'example' }
            context 'with a generated key' do
              let(:valid_params) { { url: url } }
              it 'finds and returns a record of URL with a generated key' do
                shortened_url_existent =
                  Shortener::ShortenedUrl.generate("https://www.mesalva.com/#{url}",
                                                   owner: user)
                expect do
                  post :create, params: valid_params
                end.to change(Shortener::ShortenedUrl, :count).by(0)
                expect(response).to have_http_status(:ok)
                expect(parsed_response['shortened_url'].split('/').last).to \
                  eq(shortened_url_existent.unique_key)
              end
            end
            context 'with a custom key' do
              let(:custom_key_existent) { 'h5kd97uhg6' }
              let(:valid_params) { { url: url, custom_key: custom_key_existent } }
              it 'finds and returns a record of URL with a custom key' do
                Shortener::ShortenedUrl.generate("https://www.mesalva.com/#{url}",
                                                 owner: user,
                                                 custom_key: custom_key_existent)
                expect do
                  post :create, params: valid_params
                end.to change(Shortener::ShortenedUrl, :count).by(0)
                expect(response).to have_http_status(:ok)
                expect(parsed_response['shortened_url'].split('/').last).to eq(custom_key_existent)
              end
            end
          end
        end
      end
      context 'with invalid params' do
        context 'with any URL' do
          let(:url) { 'https://www.mesalva.com' }
          it 'returns unprocessable entity error' do
            Shortener::ShortenedUrl.generate(url)
            expect do
              post :create
            end.to change(Shortener::ShortenedUrl, :count).by(0)
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end
    end
    context 'without user session' do
      it 'returns unauthorized' do
        expect do
          post :create
        end.to change(Shortener::ShortenedUrl, :count).by(0)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #show' do
    context 'with user session' do
      before { user_session }
      context 'with a generate unique key from a shortened URL' do
        let(:url) { 'https://www.mesalva.com/teste1' }
        it 'returns the original URL and increment one to the use_count' do
          shortened_url_existent = Shortener::ShortenedUrl.generate(url, owner: user)
          get :show, params: { token: shortened_url_existent[:unique_key] }
          expect(response).to have_http_status(:ok)
          expect(parsed_response['url']).to eq(url)
        end
      end
      context 'with a custom unique key from a shortened URL' do
        let(:custom_key_existent) { 'h5kd97uhg6' }
        let(:url) { 'https://www.mesalva.com/teste1' }
        it 'returns the original URL and increment one to the use_count' do
          Shortener::ShortenedUrl.generate(url, owner: user, custom_key: custom_key_existent)
          get :show, params: { token: custom_key_existent }
          expect(response).to have_http_status(:ok)
          expect(parsed_response['url']).to eq(url)
        end
      end
      context 'with a valid unique key but no corresponding URL' do
        let(:custom_key_existent) { 'h5kd97uhg6' }
        let(:url) { 'https://www.mesalva.com/teste1' }
        let(:default_url) { 'https://www.mesalva.com/' }
        it 'returns the default URL' do
          Shortener::ShortenedUrl.generate(url, owner: user, custom_key: custom_key_existent)
          get :show, params: { token: custom_key_existent }
          expect(response).to have_http_status(:ok)
          expect(parsed_response['url']).to eq(url)
          expect(parsed_response['unique_key']).to eq(custom_key_existent)
        end
      end
    end
    context 'without user session' do
      it 'returns unauthorized' do
        get :show, params: { token: '' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #index' do
    context 'with user session' do
      before { user_session }
      context 'with shortened URLs' do
        let(:user2) { create(:user) }
        context 'without filters' do
          context 'with no pagination needed' do
            it 'returns all shortened URLs' do
              generate_shortened_urls('https://www.mesalva.com', [user, user2])
              get :index
              expect(response).to have_http_status(:ok)
              expect(parsed_response.size).to eq(8)
            end
          end
          context 'with pagination needed' do
            it 'returns all shortened URLs of the page 1' do
              generate_shortened_urls_for_pag_no_filters('https://www.mesalva.com', [user, user2])
              get :index, params: { page: 1 }
              expect(response).to have_http_status(:ok)
              expect(parsed_response.size).to eq(20)
            end
            it 'returns all shortened URLs of the page 2' do
              generate_shortened_urls_for_pag_no_filters('https://www.mesalva.com', [user, user2])
              get :index, params: { page: 2 }
              expect(response).to have_http_status(:ok)
              expect(parsed_response.size).to eq(10)
            end
          end
        end
        context 'with user filter' do
          it 'returns shortened URLs filtered by user' do
            generate_shortened_urls('https://www.mesalva.com', [user, user2])
            get :index, params: { user_id: user2.id }
            expect(response).to have_http_status(:ok)
            expect(parsed_response.size).to eq(4)
            expect(parsed_response.first['owner_id']).to eq(user2.id)
          end
        end
        context 'with category filter' do
          let(:category) { "category_a" }
          it 'returns shortened URLs filtered by category' do
            generate_shortened_urls('https://www.mesalva.com', [user, user2])
            get :index, params: { category: category }
            expect(response).to have_http_status(:ok)
            expect(parsed_response.size).to eq(2)
            expect(parsed_response.first['category']).to eq(category)
            expect(parsed_response.second['category']).to eq(category)
          end
        end
        context 'with expiration filter' do
          context 'with two different dates' do
            let(:start_date) { Date.today + 1.day }
            let(:end_date) { Date.today + 3.days }
            it 'returns shortened URLs filtered by expiration between two dates' do
              generate_shortened_urls('https://www.mesalva.com', [user, user2])
              get :index, params: { start_date: start_date, end_date: end_date }
              expect(response).to have_http_status(:ok)
              expect(parsed_response.size).to eq(2)
              expect(Date.parse(parsed_response.first['expires_at'])).to \
                be_between(start_date, end_date)
              expect(Date.parse(parsed_response.second['expires_at'])).to \
                be_between(start_date, end_date)
            end
          end
          context 'with two equal dates' do
            let(:start_date) { Date.today + 2.day }
            let(:end_date) { Date.today + 2.days }
            it 'returns shortened URLs filtered by expiration equals to a date' do
              generate_shortened_urls('https://www.mesalva.com', [user, user2])
              get :index, params: { start_date: start_date, end_date: end_date }
              expect(response).to have_http_status(:ok)
              expect(parsed_response.size).to eq(1)
              expect(Date.parse(parsed_response.first['expires_at'])).to eq(start_date)
            end
          end
          context 'with just one date' do
            context 'with start date' do
              let(:start_date) { Date.today + 3.days }
              it 'returns shortened URLs filtered by expiration equals to a date' do
                generate_shortened_urls('https://www.mesalva.com', [user, user2])
                get :index, params: { start_date: start_date }
                expect(response).to have_http_status(:ok)
                expect(parsed_response.size).to eq(1)
                expect(Date.parse(parsed_response.first['expires_at'])).to eq(start_date)
              end
            end
            context 'with end date' do
              let(:end_date) { Date.today + 3.days }
              it 'returns shortened URLs filtered by expiration equals to a date' do
                generate_shortened_urls('https://www.mesalva.com', [user, user2])
                get :index, params: { end_date: end_date }
                expect(response).to have_http_status(:ok)
                expect(parsed_response.size).to eq(1)
                expect(Date.parse(parsed_response.first['expires_at'])).to eq(end_date)
              end
            end
          end
          context 'with expiration date defined' do
            it 'returns shortened URLs filtered records with expiration date' do
              generate_shortened_urls('https://www.mesalva.com', [user, user2])
              get :index, params: { expiration_date_existent: true }
              expect(response).to have_http_status(:ok)
              expect(parsed_response.size).to eq(4)
              expect(parsed_response[0]['expires_at']).not_to eq(nil)
              expect(parsed_response[1]['expires_at']).not_to eq(nil)
              expect(parsed_response[2]['expires_at']).not_to eq(nil)
              expect(parsed_response[3]['expires_at']).not_to eq(nil)
            end
          end
          context 'with expiration date not defined' do
            it 'returns shortened URLs filtered records with no expiration date' do
              generate_shortened_urls('https://www.mesalva.com', [user, user2])
              get :index, params: { expiration_date_existent: false }
              expect(response).to have_http_status(:ok)
              expect(parsed_response.size).to eq(4)
              expect(parsed_response[0]['expires_at']).to eq(nil)
              expect(parsed_response[1]['expires_at']).to eq(nil)
              expect(parsed_response[2]['expires_at']).to eq(nil)
              expect(parsed_response[3]['expires_at']).to eq(nil)
            end
          end
        end
        context 'with all the filters' do
          let(:category) { "category_c" }
          let(:start_date) { Date.today + 1.day }
          let(:end_date) { Date.today + 3.days }
          context 'with no pagination needed' do
            it 'returns shortened URLs filtered by all the filters' do
              generate_shortened_urls('https://www.mesalva.com', [user, user2])
              get :index, params: { user_id: user.id,
                                    category: category,
                                    start_date: start_date,
                                    end_date: end_date }
              expect(response).to have_http_status(:ok)
              expect(parsed_response.size).to eq(1)
              expect(parsed_response.first['owner_id']).to eq(user.id)
              expect(parsed_response.first['category']).to eq(category)
              expect(Date.parse(parsed_response.first['expires_at'])).to \
                be_between(start_date, end_date)
            end
          end
          context 'with pagination needed' do
            it 'returns shortened URLs filtered by all the filters of the page 1' do
              generate_shortened_urls_for_pag_with_filters('https://www.mesalva.com', [user, user2])
              get :index, params: { user_id: user.id,
                                    category: category,
                                    start_date: start_date,
                                    end_date: end_date,
                                    page: 1 }
              expect(response).to have_http_status(:ok)
              expect(parsed_response.size).to eq(20)
              expect(parsed_response.first['owner_id']).to eq(user.id)
              expect(parsed_response.first['category']).to eq(category)
              expect(Date.parse(parsed_response.first['expires_at'])).to \
                be_between(start_date, end_date)
            end
            it 'returns shortened URLs filtered by all the filters of the page 2' do
              generate_shortened_urls_for_pag_with_filters('https://www.mesalva.com', [user, user2])
              get :index, params: { user_id: user.id,
                                    category: category,
                                    start_date: start_date,
                                    end_date: end_date,
                                    page: 2 }
              expect(response).to have_http_status(:ok)
              expect(parsed_response.size).to eq(10)
              expect(parsed_response.first['owner_id']).to eq(user.id)
              expect(parsed_response.first['category']).to eq(category)
              expect(Date.parse(parsed_response.first['expires_at'])).to \
                be_between(start_date, end_date)
            end
          end
        end
      end
    end
    context 'without user session' do
      it 'returns unauthorized' do
        expect do
          post :index
        end.to change(Shortener::ShortenedUrl, :count).by(0)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  private

  # rubocop:disable Metrics/AbcSize
  def generate_shortened_urls(base_url, users)
    Shortener::ShortenedUrl.generate("#{base_url}/test1", owner: users[0])
    Shortener::ShortenedUrl.generate("#{base_url}/test2", owner: users[0], category: 'category_a')
    Shortener::ShortenedUrl.generate("#{base_url}/test3",
                                     owner: users[0],
                                     category: 'category_b',
                                     expires_at: Date.today)
    Shortener::ShortenedUrl.generate("#{base_url}/test4",
                                     owner: users[0],
                                     category: 'category_c',
                                     expires_at: Date.today + 2.days)
    Shortener::ShortenedUrl.generate("#{base_url}/test5", owner: users[1])
    Shortener::ShortenedUrl.generate("#{base_url}/test6", owner: users[1], category: 'category_a')
    Shortener::ShortenedUrl.generate("#{base_url}/test7",
                                     owner: users[1],
                                     category: 'category_b',
                                     expires_at: Date.today)
    Shortener::ShortenedUrl.generate("#{base_url}/test8",
                                     owner: users[1],
                                     category: 'category_c',
                                     expires_at: Date.today + 3.days)
  end
  # rubocop:enable Metrics/AbcSize

  def generate_shortened_urls_for_pag_no_filters(base_url, users)
    (1..20).each do |i|
      Shortener::ShortenedUrl.generate("#{base_url}/test#{i}", owner: users[0])
    end
    (1..10).each do |i|
      Shortener::ShortenedUrl.generate("#{base_url}/test#{i}", owner: users[1])
    end
  end

  def generate_shortened_urls_for_pag_with_filters(base_url, users)
    (1..30).each do |i|
      Shortener::ShortenedUrl.generate("#{base_url}/test#{i}",
                                       owner: users[0],
                                       category: 'category_c',
                                       expires_at: Date.today + 2.days)
    end
  end
end
