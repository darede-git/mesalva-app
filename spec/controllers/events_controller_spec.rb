# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
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

  describe.skip 'POST #create' do
    context 'user is present' do
      before :each do
        full_user_session
      end

      context 'item is free' do
        before :each do
          free_item
        end

        context 'permalink ends with medium' do
          context 'medium type is text' do
            before :each do
              medium_to_type(:text)
            end

            context 'action is read' do
              it 'creates a permalink read event' do
                assert_event_creation('text_read')
              end
            end
          end

          context 'medium type is video' do
            context 'event_name is download' do
              it 'creates a permalink download event' do
                assert_update_user_last_modules_worker_call(true)
                assert_create_intercom_worker_call(
                  event_name: 'download',
                  permalink: complete_permalink,
                  custom_headers: event_data_headers
                )

                expect(PermalinkEventDocumentWorker).to receive(:perform_async).once
                expect do
                  post :create,
                       params: { slug: complete_permalink.slug,
                                 event_name: 'download' }
                end.to change(PermalinkEvent, :count).by(1)

                assert_type_and_status(:ok)
              end
            end

            context 'event_name is watch' do
              context 'without source' do
                it 'creates a permalink watch event' do
                  assert_event_creation('lesson_watch')
                end
              end
            end

            context 'event_name is rate' do
              it 'creates a permalink rate event' do
                assert_update_user_last_modules_worker_call(true)
                assert_create_intercom_worker_call(
                  event_name: 'content_rate',
                  permalink: complete_permalink,
                  custom_headers: event_data_headers,
                  rating: '3'
                )
                expect(PermalinkEventDocumentWorker).to receive(:perform_async).once
                expect do
                  post :create,
                       params: { slug: complete_permalink.slug,
                                 event_name: 'content_rate',
                                 rating: 3 }
                end.to change(PermalinkEvent, :count).by(1)

                assert_type_and_status(:ok)
              end
            end
          end

          context 'medium type is exercise' do
            before :each do
              medium_to_type(:comprehension_exercise)
            end

            let!(:correct_answer_id) do
              complete_permalink.medium.correct_answer_id
            end

            it 'returns the correct answer' do
              assert_update_user_last_modules_worker_call(true)
              assert_create_intercom_worker_call(
                event_name: 'exercise_answer',
                submission_token: 'asd123zxc456',
                permalink: complete_permalink,
                custom_headers: event_data_headers,
                answer_id: correct_answer_id.to_s,
                correct_answer: true
              )

              expect(PermalinkEventDocumentWorker).to receive(:perform_async).once
              expect do
                post :create,
                     params: { slug: complete_permalink.slug,
                               event_name: 'exercise_answer',
                               submission_token: 'asd123zxc456',
                               answer_id: correct_answer_id }
              end.to change(PermalinkEvent, :count).by(1)

              expect(parsed_response['meta']['answer-id'])
                .to eq correct_answer_id
              expect(parsed_response['meta']['correction'])
                .to eq 'sample correction'
            end
          end
        end
      end

      context 'item is not free' do
        context 'user has access' do
          before :each do
            create(:access,
                   user_id: user.id,
                   package_id: FactoryBot
  .create(
    :package_valid_with_price,
    node_ids: [
      complete_permalink.nodes.first.id
    ]
  ).id,
                   expires_at: Time.now + 1.month,
                   starts_at: Time.now - 1.week)
          end

          it 'returns ok status' do
            permalink_events.each do |event|
              medium_to_type(:comprehension_exercise) if
              event[:event_name] == 'exercise_answer'

              assert_update_user_last_modules_worker_call(true)
              expect(PermalinkEventDocumentWorker).to receive(:perform_async).once
              expect do
                post :create, params: { slug: complete_permalink.slug, **event }
              end.to change(PermalinkEvent, :count).by(1)

              assert_type_and_status(:ok)
            end
          end
        end
      end
    end

    context 'user is not present' do
      it 'returns unauthorized' do
        assert_update_user_last_modules_worker_call(false)
        assert_create_worker_is_not_called('Intercom')

        expect do
          permalink_events.each do |event|
            post :create, params: { slug: complete_permalink.slug, **event }
            assert_unauthorized
          end
        end.to change(PermalinkEvent, :count)
          .by(0).and change(PermalinkEventDocument, :count).by(0)
      end
    end
  end

  def assert_event_creation(event_name)
    assert_create_intercom_worker_call(event_name: event_name,
                                       permalink: complete_permalink,
                                       custom_headers: event_data_headers)
    assert_update_user_last_modules_worker_call(true)
    expect(PermalinkEventDocumentWorker).to receive(:perform_async).once
    expect do
      create_event(event_name)
    end.to change(PermalinkEvent, :count).by(1)
    assert_type_and_status(:ok)
  end

  def create_event(event_name)
    post :create,
         params: { slug: complete_permalink.slug,
                   event_name: event_name }
  end

  def permalink_events
    [{ event_name: 'lesson_watch' },
     { event_name: 'content_rate', rating: '3' },
     { event_name: 'exercise_answer', answer_id: '3', answer_correct: false }]
  end

  def free_item
    complete_permalink.item.free = true
    complete_permalink.item.save
  end

  def medium_to_type(type, medium = complete_permalink.medium)
    attrs = FactoryBot.attributes_for("medium_#{type}".to_sym,
                                      :valid_answers_attributes)
    medium.update_attributes(attrs)
    complete_permalink.reload
  end
end
