# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MediaController, type: :controller do
  include RelationshipOrderAssertionHelper
  include ContentStructureAssertionHelper

  let!(:medium) { create(:medium) }
  let(:item) { create(:item) }
  let(:node) { create(:node) }
  let(:permalink) { create(:permalink) }
  let(:valid_attributes) { FactoryBot.attributes_for(:medium) }
  let(:valid_attributes1) { FactoryBot.attributes_for(:medium_pdf) }
  let(:valid_attributes2) { FactoryBot.attributes_for(:medium_exercise) }
  let(:valid_attributes3) { FactoryBot.attributes_for(:medium_book) }
  let(:valid_attributes4) { FactoryBot.attributes_for(:medium_essay_video) }
  let(:valid_attributes5) { FactoryBot.attributes_for(:medium_correction_video) }

  describe 'POST #create' do
    context 'as admin' do
      before { admin_session }
      context 'with valid params' do
        it 'creates one new Medium' do
          expect do
            post :create, params: valid_attributes
          end.to change(Medium, :count).by(1)
          medium = Medium.last
          expect(medium.created_by).to eq(admin.uid)
          asserts_jsonapi_and_relationships(:created, medium)
        end

        it 'creates several new Media' do
          expect do
            post :mass_creation, params: { media:
                                          [valid_attributes, valid_attributes1,
                                           valid_attributes2] }
          end.to change(Medium, :count).by(3)
        end

        context '#book' do
          it 'creates one new Medium' do
            expect do
              post :create, params: valid_attributes3
            end.to change(Medium, :count).by(1)
            medium = Medium.last
            expect(medium.created_by).to eq(admin.uid)
            asserts_jsonapi_and_relationships(:created, medium)
          end
        end

        context '#essay_video' do
          it 'creates one new Medium' do
            expect do
              post :create, params: valid_attributes4
            end.to change(Medium, :count).by(1)
            medium = Medium.last
            expect(medium.created_by).to eq(admin.uid)
            asserts_jsonapi_and_relationships(:created, medium)
          end
        end

        context '#correction_video' do
          it 'creates one new Medium' do
            expect do
              post :create, params: valid_attributes5
            end.to change(Medium, :count).by(1)
            medium = Medium.last
            expect(medium.created_by).to eq(admin.uid)
            asserts_jsonapi_and_relationships(:created, medium)
          end
        end

        context '#exercise' do
          context 'fixation' do
            it 'creates a new Medium' do
              asserts_create_action(attributes_for(:medium_fixation_exercise,
                                                   :valid_answers_attributes))
            end
          end

          context 'comprehension' do
            it 'creates a new Medium' do
              asserts_create_action(
                attributes_for(:medium_comprehension_exercise,
                               :valid_answers_attributes)
              )
            end
          end
        end
      end

      context 'with invalid params' do
        it 'returns http unprocessable_entity' do
          asserts_create_action_invalid(:medium_invalid)
        end

        context '#exercise' do
          context 'fixation' do
            context 'without correct answer' do
              it 'returns http unprocessable_entity' do
                asserts_create_action_invalid(
                  :medium_fixation_exercise,
                  :answers_attributes_without_correct_answer
                )
              end
            end

            context 'with one answers' do
              it 'returns http unprocessable_entity' do
                asserts_create_action_invalid(
                  :medium_fixation_exercise,
                  :answers_attributes_with_one_answer
                )
              end
            end

            context 'with twice correct answers' do
              it 'returns http unprocessable_entity' do
                asserts_create_action_invalid(
                  :medium_fixation_exercise,
                  :answers_attributes_with_twice_correct
                )
              end
            end

            context 'without text' do
              it 'returns http unprocessable_entity' do
                asserts_create_action_invalid(
                  :medium_fixation_exercise,
                  :answers_attributes_without_text
                )
              end
            end
          end
        end
      end
      context 'as user' do
        before { user_session }
        context 'with valid params' do
          it 'returns http unauthorized' do
            post :create, params: valid_attributes

            assert_type_and_status(:unauthorized)
          end
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'as admin' do
      before { admin_session }
      context 'with valid params' do
        it 'updates the requested medium' do
          put :update, params: { id: medium.to_param, name: 'another medium' }

          medium.reload
          expect(medium.name).to eq('another medium')
          expect(medium.updated_by).to eq(admin.uid)
          asserts_jsonapi_and_relationships(:ok, medium)
        end

        it 'updates the requested medium with listed flag' do
          put :update, params: { id: medium.to_param, listed: false }

          medium.reload
          expect(medium.listed).to eq false
          asserts_jsonapi_and_relationships(:ok, medium)
        end
      end

      it_should_behave_like 'a removable related entity',
                            [{ self: :medium, related: :node },
                             { self: :medium, related: :node_module },
                             { self: :medium, related: :item }]

      it_behaves_like 'controller #update with inactive "has_many" relations',
                      entity: :medium, relations: %i[node node_module item]

      context 'with invalid params' do
        it 'returns http code 422 unprocessable_entity' do
          put :update, params: { id: medium.to_param, name: '' }

          assert_type_and_status(:unprocessable_entity)
        end
      end
    end
    context 'as user' do
      before { user_session }
      context 'with valid params' do
        it 'returns http unauthorized' do
          put :update, params: { id: medium.to_param, name: 'another medium' }

          assert_type_and_status(:unauthorized)
        end
      end

      context 'when sending platform_id' do
        before { user_session }
        let!(:platform) { create(:platform) }
        let!(:user_platform) do
          create(:user_platform,
                 user_id: user.id,
                 platform_id: platform.id,
                 role: "student")
        end
        let(:parent_item_mesalva) { create(:item) }
        let(:parent_item_platform) { create(:item, platform_id: platform.id) }

        it 'cannot update platform medium' do
          put :update, params: { id: medium.id,
                                 name: 'some other name',
                                 item_ids: [parent_item_platform.id],
                                 platform_id: platform.id }
          expect(response).to have_http_status(:unauthorized)
        end

        it 'cannot update a medium under the mesalva item' do
          put :update, params: { id: medium.id,
                                 name: 'some other name',
                                 item_ids: [parent_item_mesalva.id],
                                 platform_id: platform.id }
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
    context 'as platform admin' do
      before { user_platform_admin_session }
      let(:parent_item_mesalva) { create(:item) }
      let(:parent_item_platform) do
        create(:item, platform_id: user_platform_admin.platform.id)
      end

      it 'can update a medium under the platform item' do
        put :update, params: { id: medium.id,
                               name: 'some other name',
                               item_ids: [parent_item_platform.id] }
        expect(response).to have_http_status(:ok)
      end

      it 'cannot update a medium under the mesalva item' do
        put :update, params: { id: medium.id,
                               name: 'some other name',
                               item_ids: [parent_item_mesalva.id] }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as admin' do
      before { admin_session }
      it 'destroys the requested medium' do
        expect do
          delete :destroy, params: { id: medium.to_param }
        end.to change(Medium, :count).by(-1)

        expect(response).to have_http_status(:no_content)
        expect(response.content_type).to eq(nil)
      end
    end
    context 'as user' do
      before { user_session }
      it 'returns http unauthorized' do
        delete :destroy, params: { id: medium.to_param }

        assert_type_and_status(:unauthorized)
      end
    end
  end

  describe 'GET #show' do
    before(:each) do
      Rails.cache.clear
    end

    context 'valid requests' do
      before do
        item.medium_ids = [medium.id]
        permalink.node_ids = [node.id]
        permalink.medium_id = medium.id
        permalink.item_id = item.id
        permalink.save
      end

      context 'when user is guest' do
        context 'and permalink item is not free' do
          it_behaves_like 'a payment or login required for', %w[
            text
            streaming video
            pdf
            public_document
            essay_video
            correction_video
          ] do
            let(:status) { 'unauthorized' }
          end

          it_behaves_like 'a viewable exercise medium'
          it_behaves_like 'a viewable medium for', %w[essay]
        end

        context 'and permalink item is free' do
          before do
            item.update(free: true)
          end

          it_behaves_like 'a payment or login required for', %w[
            video
            pdf
            essay_video
            correction_video
          ] do
            let(:status) { 'unauthorized' }
          end

          it_behaves_like 'a viewable medium for', %w[essay
                                                      text
                                                      public_document]
          it_behaves_like 'a viewable exercise medium'

          context 'item and medium are streaming and streaming_status'\
          'different from "recorded"' do
            before do
              medium_and_item_to_streaming('scheduled')
            end

            it 'allows guest to receive medium' do
              get :show, params: { slug: medium.slug,
                                   permalink_slug: permalink.slug }
              assert_jsonapi_response(
                :ok, permalink.medium,
                Permalink::Relation::ChildMediumSerializer
              )
            end
          end

          context 'item and medium are streaming and streaming_status'\
          'is "recorded"' do
            before do
              medium_and_item_to_streaming('recorded')
            end
            it 'does not allow guest to receive medium' do
              get :show, params: { slug: medium.slug,
                                   permalink_slug: permalink.slug }
              assert_type_and_status(:unauthorized)
            end
          end
        end
      end

      context 'user is present' do
        before do
          user_session
        end
        context 'and permalink item is not free' do
          context 'and user does not have access' do
            it_behaves_like 'a payment or login required for', %w[
              text
              streaming
              video
              pdf
              public_document
              essay_video
              correction_video
            ] do
              let(:status) { 'payment_required' }
            end

            it_behaves_like 'a viewable medium for', %w[essay]
            it_behaves_like 'a viewable exercise medium'
          end

          context 'and user does have access' do
            before do
              create(
                :access, :one_month,
                user_id: user.id,
                package: create(:package_valid_with_price,
                                node_ids: [node.id])
              )
            end

            it_behaves_like 'a viewable medium for', %w[fixation_exercise
                                                        text
                                                        comprehension_exercise
                                                        streaming
                                                        video
                                                        pdf
                                                        essay
                                                        public_document
                                                        essay_video
                                                        correction_video]
          end
        end

        context 'and permalink item is free' do
          before do
            item.update(free: true)
          end

          it_behaves_like 'a viewable medium for', %w[video
                                                      pdf
                                                      essay
                                                      text
                                                      streaming
                                                      public_document
                                                      essay_video
                                                      correction_video]

          context 'medium type is exercises' do
            it_behaves_like 'a viewable exercise medium'

            context 'when client is app' do
              before do
                medium.medium_type = 'fixation_exercise'
                medium.audit_status = 'reviewed'
                medium.answers = [
                  Answer.new(text: 'Alternativa 1',
                             correct: true,
                             active: true),
                  Answer.new(text: 'Alternativa 2',
                             correct: false,
                             active: true),
                  Answer.new(text: 'Alternativa 3',
                             correct: false,
                             active: true),
                  Answer.new(text: 'Alternativa 4',
                             correct: false,
                             active: true),
                  Answer.new(text: 'Alternativa 5',
                             correct: false,
                             active: true)
                ]

                medium.save!
              end
              it 'returns the correct answer with each answer' do
                @request.headers[:client] = 'APP_ENEM'
                get :show, params: { slug: medium.slug,
                                     permalink_slug: permalink.slug }

                answers = parsed_response['included']
                expect(answers.first['attributes']['correct']).to be_truthy
              end
            end
          end
        end
      end
    end

    context 'invalid requests' do
      context 'user is present' do
        before do
          user_session
        end
        context 'medium does not exist' do
          it 'returns unprocessable entity' do
            get :show, params: { slug: 'medium' }
            assert_type_and_status(:not_found)
          end
        end
        context 'medium exists' do
          context 'permalink slug is not present' do
            it 'returns unprocessable entity' do
              get :show, params: { slug: medium.slug }
              assert_type_and_status(:unprocessable_entity)
            end
          end
          context 'permalink slug is present' do
            context 'permalink does not exist' do
              it 'returns unprocessable entity' do
                get :show, params: { slug: medium.slug,
                                     permalink_slug: 'invalid' }
                assert_type_and_status(:unprocessable_entity)
              end
            end
            context 'permalink exists' do
              context 'permalink does not contain the medium' do
                it 'returns unprocessable entity' do
                  get :show, params: { slug: medium.slug,
                                       permalink_slug: permalink.slug }
                  assert_type_and_status(:unprocessable_entity)
                end
              end
            end
          end
        end
      end
    end
  end
end

def medium_and_item_to_streaming(streaming_status)
  permalink.item.update_attributes!(
    FactoryBot.attributes_for(:item, "#{streaming_status}_streaming".to_sym)
  )
  permalink.medium.update_attributes!(
    FactoryBot.attributes_for(:medium_streaming)
  )
end
