# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event::PermalinkController, type: :controller do
  include_context 'permalink building'

  let!(:node) { create(:node) }
  let!(:node_permalink) do
    create(:permalink, slug: 'node_slug', nodes: [node])
  end

  describe.skip 'GET #show' do
    context 'valid permalink' do
      before { user_session }
      context 'not grouped nor expanded' do
        let!(:permalink_event) { create_permalink_event(complete_permalink.slug, user.id) }
        it "returns status ok" do
          get :show, params: { slug: item_permalink.slug }

          expect(response).to have_http_status(:ok)
        end
        it "returns counters for each medium type" do
          get :show, params: { slug: item_permalink.slug }

          expect(parsed_response['results']).to be_empty
        end
      end
      context 'group by' do
        context 'for counters feature' do
          let!(:permalink_event) { create_permalink_event(complete_permalink.slug, user.id) }
          it "returns grouped counters for each medium type" do
            get :show, params: { slug: item_permalink.slug, expanded: true, group_by: "item" }

            expect(response).to have_http_status(:ok)
            expect(parsed_response['results']).not_to be_empty
            expect(parsed_response['results'].first['media']).not_to be_empty
          end
        end
        context 'for consumed content feature' do
          context 'without event on LessonEventDocument' do
            let!(:permalink_event) { create_permalink_event(complete_permalink.slug, user.id) }
            it "returns consumed medium and creates a new event on LessonEventDocument" do
              expect do
                get :show, params: { slug: item_permalink.slug, expanded: true, group_by: "item" }
              end.to change(LessonEvent, :count).by(1)

              expect(response).to have_http_status(:ok)
              expect(parsed_response['results']).not_to be_empty
              expect(parsed_response['results'].first['item']).to \
                eq(LessonEvent.first.item_slug)
            end
          end
          context 'with one event on LessonEventDocument' do
            let!(:permalink_event) { create_permalink_event(complete_permalink.slug, user.id) }
            let!(:lesson_event) do
              create(:lesson_event_document,
                     user_token: user.token,
                     node_module_slug: NodeModule.first.slug)
            end
            it "returns consumed medium" do
              expect do
                get :show, params: { slug: item_permalink.slug, expanded: true, group_by: "item" }
              end.to change(LessonEventDocument, :count).by(0)

              expect(response).to have_http_status(:ok)
              expect(parsed_response['results']).not_to be_empty
              expect(parsed_response['results'].first['item_slug']).to eq(lesson_event['item_slug'])
            end
          end
          context 'without event on LessonEventDocument and PermalinkEventDocument' do
            it "returns empty" do
              expect do
                get :show, params: { slug: item_permalink.slug, expanded: true, group_by: "item" }
              end.to change(LessonEventDocument, :count).by(0)

              expect(response).to have_http_status(:ok)
              expect(parsed_response['results']).to be_empty
            end
          end
        end
      end
      context 'expanded' do
        let!(:permalink_event) { create_permalink_event(complete_permalink.slug, user.id) }
        it "returns grouped counters for each medium type" do
          get :show, params: { slug: item_permalink.slug, expanded: true }

          expect(parsed_response['results'].size).to eq(1)
        end
      end
    end
    context 'user is not present' do
      it 'returns error code 404' do
        get :show, params: { slug: 'invalid/slug' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  def assert_filtered_response(attrs)
    get :show, params: { slug: node_permalink.slug,
                         group_by: attrs[:group_by],
                         expanded: attrs[:expanded] }

    expect(response).to have_http_status(:ok)
    expect(parsed_response.keys).to include('results')
  end

  def create_permalink_event(permalink_slug, user_id)
    create(:permalink_event_document_content_consumed,
           created_at: Time.now,
           permalink_slug: permalink_slug,
           user_id: user_id)
  end
end
