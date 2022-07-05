# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/permalinks/builder'

RSpec.describe PrepTestEventsController, type: :controller do
  include SerializationHelper
  include PermalinkAssertionHelper
  include PermalinkEventAssertionHelper
  include PermalinkCreationHelper

  include_context 'permalink building' do
    let(:medium) do
      create(:medium_fixation_exercise,
             :valid_answers_attributes, items: [item])
    end
  end

  let(:medium2) do
    create(:medium_fixation_exercise,
           :valid_answers_attributes, items: [item])
  end

  let!(:complete_permalink2) do
    create(
      :permalink,
      slug: "#{node1.slug}/#{node2.slug}/#{node3.slug}/"\
            "#{node_module.slug}/#{item.slug}/#{medium2.slug}",
      nodes: [node1, node2, node3],
      node_module: node_module,
      item: item,
      medium: medium2
    )
  end

  let(:event_data_headers) do
    JSON.parse(File.read('spec/fixtures/event_data_headers.json'))
  end

  let(:full_user_session) do
    user_session
    add_custom_headers(event_data_headers)
  end

  let!(:address_argument) { "#{ENV['TRI_API_URL']}predict" }

  let!(:body_argument) do
    { answers: [true, false],
      blueprint: { "year": 2015,
                   "test": "linguagens",
                   "language": "esp" } }.to_json
  end

  let!(:header_argument) { { 'Content-Type' => 'application/json' } }

  let!(:predicted_score) { "{ \"predicted_score\": 308.95 }" }

  let!(:correct_answer_id) do
    complete_permalink.medium.correct_answer_id
  end

  let(:starts_at) { (Time.now - 3.hours).strftime(t('time.formats.date')) }

  let(:event_name) { "prep_test_answer" }

  let!(:answers) do
    [{ slug: complete_permalink.slug,
       event_name: event_name,
       answer_id: correct_answer_id,
       starts_at: starts_at },
     { slug: complete_permalink2.slug,
       event_name: event_name,
       answer_id: nil,
       starts_at: starts_at }]
  end

  describe.skip 'POST create' do
    before do
      Timecop.freeze(time_now)
    end

    context 'with user' do
      before { full_user_session }

      let!(:meta) do
        { 'answers' => [{ 'slug' => medium.slug,
                          'correct' => true,
                          'correction' => medium.correction,
                          'submission-token' => submission_token,
                          'medium-text' => medium.medium_text,
                          'answer-correct' => medium.correct_answer_id },
                        {
                          'slug' => medium2.slug,
                          'correct' => false,
                          'correction' => medium2.correction,
                          'submission-token' => submission_token,
                          'medium-text' => medium2.medium_text,
                          'answer-correct' => medium2.correct_answer_id
                        }] }
      end

      let(:prep_test_answer_attributes) do
        { cf_submission_token: submission_token,
          cf_node_module_name: node_module.name,
          cf_item_name: item.name }
      end
      before do
        expect_in_rd(event_name, node_module, prep_test_answer_attributes)
      end
      it 'does create prep_test events' do
        expect(PermalinkEventDocumentWorker).to receive(:perform_async).twice
        post :create, params: { answers: answers }
        assert_type_and_status(:created)

        expect(parsed_response['meta']).to eq meta
      end

      context 'when creating prep_test result' do
        before do
          create(:tri_reference, item_id: item.id)
          allow(HTTParty).to receive(:post).with(
            address_argument,
            body: body_argument,
            headers: header_argument
          ).and_return(http_party_200_response(predicted_score))
        end

        it 'should return a valid TRI score' do
          post :create, params: { answers: answers }
          expect(parsed_response['meta']['score']).to eq 308.95
        end
      end
    end

    context 'without user' do
      it 'returns unauthorized status' do
        post :create, params: { answers: answers }

        assert_type_and_status(:unauthorized)
      end
    end
  end

  describe 'GET #index' do
    context 'with user' do
      before :each do
        full_user_session
      end

      context 'when prep_tests exists' do
        before do
          create(:permalink_event_prep_test,
                 permalink_node_module_slug: node_module.slug,
                 permalink_item_slug: item.slug,
                 user_id: user.id,
                 event_name: event_name)
          create(:lesson_event,
                 node_module_slug: node_module.slug,
                 item_slug: item.slug,
                 user_id: user.id)
        end
        it 'does returns prep_tests' do
          get :index, params: { node_module_slug: node_module.slug }
          assert_type_and_status(:ok)
          expect(parsed_response['results']).to include('prep-tests')
          expect(parsed_response['results']['prep-tests'].first)
            .to include('item-slug', 'item-name',
                        'submission-token', 'submission-at')
        end
      end
    end

    context 'without user' do
      it 'returns unauthorized status' do
        get :index, params: { node_module_slug: node_module.slug }

        assert_type_and_status(:unauthorized)
      end
    end
  end

  describe.skip 'GET #show' do
    context 'with user' do
      before :each do
        full_user_session
      end

      context 'when prep_tests_answers with submission_token exists' do
        let(:token) { submission_token }
        let(:medium) { create(:medium) }
        before do
          create(:permalink_event_prep_test,
                 submission_token: token,
                 permalink_node_module_slug: node_module.slug,
                 permalink_item_slug: item.slug,
                 user_id: user.id,
                 event_name: event_name)
          create(:lesson_event,
                 node_module_slug: node_module.slug,
                 item_slug: item.slug,
                 submission_token: token,
                 user_id: user.id)
          create(:exercise_event,
                 medium_slug: medium.slug,
                 item_slug: item.slug,
                 submission_token: token,
                 user_id: user.id)
        end

        it 'does returns prep_test_answers' do
          get :show, params: { submission_token: token }

          assert_type_and_status(:ok)
          expect(parsed_response['results']).to include('created-at',
                                                        'answers',
                                                        'score',
                                                        'duration-in-seconds')
          expect(parsed_response['results']['answers'].first)
            .to include('slug', 'correct', 'answer-id',
                        'correction', 'answer-correct')
        end

        context 'when showing prep_test result' do
          before do
            Timecop.freeze(time_now)
          end
          before do
            create(:tri_reference, item_id: item.id)
          end
          let(:prep_test_answer_attributes) do
            { cf_submission_token: submission_token,
              cf_node_module_name: node_module.name,
              cf_item_name: item.name }
          end
          before do
            expect_in_rd(event_name, node_module, prep_test_answer_attributes)
          end
          before do
            allow(HTTParty).to receive(:post).with(
              address_argument,
              body: body_argument,
              headers: header_argument
            ).and_return(http_party_200_response(predicted_score))

            post :create, params: { answers: answers }

            create(:permalink_event_prep_test,
                   submission_token: last_submission_token,
                   user_id: user.id,
                   event_name: event_name)
          end

          it 'returns a valid TRI score' do
            get :show, params: {
              submission_token: last_submission_token
            }
            expect(parsed_response['results']['score']).to eq 308.95
          end
        end
      end

      context 'when prep_tests_answers does not exists' do
        it 'returns error code 404' do
          get :show, params: { submission_token: 'invalid_token' }

          assert_type_and_status(:not_found)
        end
      end
    end

    context 'without user' do
      it 'returns unauthorized status' do
        get :show, params: { submission_token: submission_token }

        assert_type_and_status(:unauthorized)
      end
    end
  end

  def submission_token
    Base64.encode64(time_now).delete("\n").delete("=")
  end

  def last_submission_token
    PrepTestScore.last[:submission_token]
  end

  def time_now
    Time.now.strftime(t('time.formats.date'))
  end

  def expect_in_rd(event_name, node_module, attributes)
    client = double
    expect(MeSalva::Crm::Rdstation::Event::Client).to receive(:new)
      .with({ user: user,
              event_name: "#{event_name}|#{node_module.slug}",
              payload: attributes })
      .and_return(client)
    expect(client).to receive(:create)
  end
end
