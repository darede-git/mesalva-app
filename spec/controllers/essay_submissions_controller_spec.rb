# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/permalinks/builder'

RSpec.shared_examples 'unauthorized essay submission' do
  it 'returns http unauthorized' do
    create_essay_submission(valid_attributes, 0)
    assert_type_and_status(:unauthorized)
  end
end

RSpec.describe EssaySubmissionsController, type: :controller do
  include PermalinkBuildingHelper

  let!(:node) { create(:node) }
  let!(:node_module) { create(:node_module, node_ids: [node.id]) }
  let!(:item) do
    create(:item, free: false, node_module_ids: [node_module.id])
  end
  let!(:medium) do
    create(:medium_essay, item_ids: [item.id])
  end

  let!(:correction_style_criteria_check) { create(:correction_style_criteria_check) }
  let!(:correction_style_criteria) { correction_style_criteria_check.correction_style_criteria }
  let!(:correction_style) { correction_style_criteria.correction_style }

  let(:package) do
    create(:package_valid_with_price, node_ids: [node.id])
  end
  let!(:create_access) do
    create(:access, user_id: user.id, package_id: package.id,
                    expires_at: Time.now + 1.month)
  end

  let!(:essay_submission) do
    build_permalinks(node, :subtree)
    create(:essay_submission_with_essay,
           :correcting,
           permalink: medium.permalinks.first,
           correction_style: correction_style,
           user: user).reload
  end

  let(:create_expired_access) do
    create(:access, user_id: user.id, package_id: package.id,
                    expires_at: Time.now - 1.month, active: false)
  end
  let(:admin) do
    create(:admin)
  end

  describe 'GET #index' do
    let!(:essay_awaiting_correction) { create(:essay_submission_with_essay, user: user) }

    context 'as an admin' do
      before { authentication_headers_for(admin) }
      let!(:essay_awaiting_correction2) { create(:essay_submission_with_essay, user: user) }
      let!(:essay_correcting) do
        create(:essay_submission_with_essay, :correcting, user: user)
      end
      let!(:essay_inactive) do
        create(:essay_submission_with_essay, :correcting, user: user, active: false)
      end

      context 'without filters' do
        it 'returns all essay submissions except pending (only draft)' do
          get :index
          assert_index_admin([essay_submission,
                              essay_correcting])
        end
      end

      context 'with correction style filter' do
        it 'returns essay submissions filtered' do
          get :index, params: { correction_style_id: correction_style.id }

          assert_index_admin([essay_submission])
        end
      end

      context 'with status filter' do
        it 'return essays with given status' do
          get :index, params: { status: 'awaiting_correction', order_by: 'asc' }

          assert_index_admin([essay_awaiting_correction,
                              essay_awaiting_correction2])
        end
      end

      context 'with uid filter' do
        it 'return essays filtered by user uid' do
          get :index, params: { uid: user.uid, order_by: 'asc' }

          assert_index_admin([essay_submission])
        end
      end

      context 'with permalink_slug filter' do
        it 'returns essays filtered by permalink slug' do
          get :index, params: { permalink_slug: medium.permalinks.first.slug }

          assert_index_admin([essay_submission])
        end
      end

      context 'with node_module_slug filter' do
        it 'returns essays filtered by node_module_slug' do
          get :index, params: { node_module_slug: node_module.slug }

          assert_index_admin([essay_submission])
        end
      end

      context 'with package filter' do
        before do
          create(:access, :one_month, user_id: user.id, package_id: package.id)
        end
        it 'returns essays filtered by package' do
          get :index, params: { package_id: package.id }

          assert_index_admin([essay_submission])
        end
      end

      context 'with platform_unity_slug filter' do
        let!(:essay_submission_with_platform) do
          create(:essay_submission,
                 platform: user_platform.platform,
                 user_id: user_platform.user_id,
                 status: 1)
        end
        it 'return essays filtered by platform_unity_slug' do
          PlatformUnity.last.update(platform_id: essay_submission_with_platform.platform.id,
                                    slug: 'João Paulo II',
                                    name: 'João Paulo II')

          get :index, params: { platform_slug: user_platform.platform.slug,
                                platform_unity_slug: PlatformUnity.last.slug }
          expect(parsed_response['data'].count).to eq(1)
          expect(parsed_response['data'].first['attributes']['status']).to eq('awaiting_correction')

          assert_index_admin([essay_submission_with_platform])
        end
      end

      context 'with order desc' do
        it 'return older essays first' do
          get :index, params: { status: 'awaiting_correction',
                                order_by: 'desc' }

          assert_index_admin([essay_awaiting_correction2,
                              essay_awaiting_correction])
        end
      end

      context 'with param order invalid' do
        it 'return unprocessable_entity' do
          authentication_headers_for(admin)
          get :index, params: { status: 'awaiting_correction',
                                order_by: 'invalid' }

          assert_type_and_status(:unprocessable_entity)
        end
      end

      context 'with filter correction_type' do
        let!(:custom_essay) do
          create(:essay_submission_with_essay,
                 :correcting,
                 correction_type: 'redacao-personalizada',
                 user: user)
        end
        it 'return essays with given correction_type' do
          get :index, params: { correction_type: 'redacao-personalizada' }

          assert_index_admin([custom_essay])
        end
      end

      context 'with filter updated by uid' do
        let!(:essay_updated_by) do
          create(:essay_submission_with_essay,
                 :correcting,
                 updated_by_uid: admin.uid,
                 user: user)
        end
        it 'return essays filtered by updated user uid' do
          get :index, params: { updated_by_uid: admin.uid }

          assert_index_admin([essay_updated_by])
        end
      end

      context 'without platform_slug filter' do
        before do
          create(:access, :one_month, user_id: user.id, package_id: package.id)
        end

        let!(:platform) { create(:platform) }

        let!(:essay_submission3) do
          create(:essay_submission_with_essay,
                 :corrected_custom,
                 correction_style_id: correction_style.id,
                 user: user,
                 permalink: medium.permalinks.first,
                 platform: platform,
                 updated_by_uid: admin.uid)
        end

        it 'returns only essays without platform or platform enem' do
          get :index, params: { correction_style_id: correction_style.id, uid: user.uid }

          assert_index_admin([essay_submission])
        end
      end

      context 'with all filters' do
        before { user_platform_session }
        before do
          create(:access, :one_month,
                 platform_id: user_platform.platform.id,
                 user_id: user_platform.user.id, package_id: package.id)
        end

        let!(:essay_submission2) do
          create(:essay_submission_with_essay,
                 :corrected_custom,
                 updated_by_uid: admin.uid,
                 user: user)
        end

        let!(:essay_submission3) do
          create(:essay_submission_with_essay,
                 :corrected_custom,
                 correction_style_id: correction_style.id,
                 user: user_platform.user,
                 permalink: medium.permalinks.first,
                 platform: user_platform.platform,
                 updated_by_uid: admin.uid)
        end

        it 'return essays using all filters' do
          get :index, params: { correction_style_id: correction_style.id,
                                status: 'corrected',
                                uid: user_platform.user.uid,
                                correction_type: 'redacao-personalizada',
                                package_id: package.id,
                                item_name: medium.permalinks.first.item_name,
                                node_module: node_module.slug,
                                platform_slug: user_platform.platform.slug,
                                updated_by_uid: admin.uid,
                                platform_unity_slug: user_platform.platform_unity.slug }
          assert_type_and_status(:success)
          expect(parsed_response['data']).to include(
            parsed_essay_submissions(essay_submission3)['data']
          )
        end
      end
    end

    context 'as an user' do
      before do
        authentication_headers_for(user)
      end

      context 'without filters' do
        before { essay_submission.update(active: false) }
        it 'returns all essay submissions by user even inactive' do
          get :index

          assert_type_and_status(:success)
          expect(parsed_response['data']).to eq(
            parsed_essay_submissions([essay_submission, essay_awaiting_correction])['data']
          )
          expect(parsed_response).to include('links')
        end
      end

      context 'with all filters' do
        before do
          create(:essay_submission_with_essay, :corrected_custom,
                 updated_by_uid: admin.uid, user: user)
          create(:essay_submission_with_essay, :correcting,
                 updated_by_uid: admin.uid, user: user)
          create(:essay_submission_with_essay, :correcting,
                 permalink: medium.permalinks.first, user: user)
        end
        let!(:essay_submisssion_filtred) do
          create(:essay_submission_with_essay, :correcting,
                 correction_style_id: correction_style.id,
                 correction_type: 'redacao-personalizada',
                 updated_by_uid: admin.uid,
                 user: user,
                 permalink: medium.permalinks.first)
        end

        it 'return essays using all filters' do
          get :index, params: { correction_style_id: correction_style.id,
                                status: 'correcting',
                                correction_type: 'redacao-personalizada',
                                updated_by_uid: admin.uid,
                                permalink_slug: medium.permalinks.first.slug }

          assert_type_and_status(:success)

          expect(parsed_response['data']).to eq(
            parsed_essay_submissions([essay_submisssion_filtred])['data']
          )
          expect(parsed_response).to include('links')
        end
      end
    end

    context 'without authentication' do
      it 'returns http unauthorized' do
        get :index

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #show' do
    context 'as an user' do
      before do
        create(:essay_submission_grade,
               essay_submission: essay_submission,
               correction_style_criteria: essay_submission.correction_style
              .correction_style_criterias.first)
      end
      it 'returns the essay submission' do
        authentication_headers_for(user)

        get :show, params: { id: essay_submission.token }

        assert_apiv2_response(:success,
                              essay_submission,
                              V2::EssaySubmissionSerializer,
                              %i[user correction_style essay_submission_grades])
        expect(parsed_response['data']['relationships']['user']['data']['id'])
          .to eq(essay_submission.user.uid)
      end
    end

    context 'without match user' do
      it 'returns unauthorized' do
        other_user = create(:user)
        authentication_headers_for(other_user)
        get :show, params: { id: essay_submission.token }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'as a guest' do
      it 'returns unauthorized' do
        get :show, params: { id: essay_submission.token }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT# VERIFY' do
    let(:valid_attributes) do
      attributes_for(:essay_submission,
                     permalink_slug: medium.permalinks.first.slug,
                     correction_style_id: correction_style.id)
    end

    context 'as an user' do
      before { authentication_headers_for(user) }
      context 'with valid access' do
        before { create_access }

        context 'when reached max pending essay' do
          it 'expect unauthorized status' do
            put :verify
            expect(response.status).to eq(401)
            expect(parsed_response).to eq("errors" =>
              ["você chegou ao limite de redações submetidas aguardando correção."])
          end
        end

        context 'when has space to send another essay' do
          before { package.update(max_pending_essay: 2) }
          it 'expect receive an array items that user cannot send' do
            create_essay_submission(valid_attributes, 1)
            EssaySubmission.last.update(status: 1)

            put :verify
            expect(parsed_response[0]["id"]).to eq(item.id)
          end
        end
      end
    end
  end

  describe 'POST create' do
    let(:invalid_attributes) do
      { correction_style_id: correction_style.id,
        permalink_slug: '', essay: 'data:image/jpeg;' }
    end

    let(:valid_attributes) do
      attributes_for(:essay_submission,
                     permalink_slug: medium.permalinks.first.slug,
                     correction_style_id: correction_style.id)
    end

    context 'as an user' do
      before { authentication_headers_for(user) }
      context 'with valid access' do
        before { create_access }

        context 'with valid attributes' do
          context 'without essay' do
            it 'create a essay submission' do
              create_essay_submission(valid_attributes, 1)

              expect(EssaySubmission.last.reload.status).to eq(0)
              assert_apiv2_response(:created,
                                    EssaySubmission.last,
                                    V2::EssaySubmissionSerializer)
            end
          end

          context 'with essay' do
            before do
              valid_attributes.merge!(essay: 'data:image/png;base64,iVBORw0KGg'\
                'oAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP4z8DwHwAFAAH'\
                '/VscvDQAAAABJRU5ErkJggg==')
            end

            context 'with essay credits' do
              it 'create a essay submission with status awaiting correction' do
                create_essay_submission(valid_attributes, 1)

                expect(EssaySubmission.last.reload.status).to eq(1)
                assert_apiv2_response(:created,
                                      EssaySubmission.last,
                                      V2::EssaySubmissionSerializer)
              end

              it 'subtracts an essay credit after send' do
                expect(user.reload.accesses.first.essay_credits).to eq(9)

                post :create, params: valid_attributes

                expect(response).to have_http_status(:created)
                expect(user.reload.accesses.first.essay_credits).to eq(8)
              end

              it 'subtracts from the first expiring access' do
                first_expiring_access =
                  create(:access, user_id: user.id,
                                  package_id: package.id,
                                  expires_at: Time.now + 1.week)

                expect(first_expiring_access.essay_credits).to eq(10)

                post :create, params: valid_attributes

                expect(first_expiring_access.reload.essay_credits).to eq(9)
                expect(create_access.reload.essay_credits).to eq(9)
              end

              it 'subtracts from the available access' do
                first_expiring_access =
                  create(:access, user_id: user.id,
                                  package_id: package.id,
                                  expires_at: Time.now + 1.week)
                first_expiring_access.update(essay_credits: 0)

                post :create, params: valid_attributes

                expect(first_expiring_access.reload.essay_credits).to eq(0)
                expect(create_access.reload.essay_credits).to eq(8)
              end
            end

            context 'with not enough essay credits' do
              it 'renders unauthorized' do
                user.reload.accesses.first.update(essay_credits: 0)

                post :create, params: valid_attributes

                expect(response).to have_http_status(:unauthorized)
              end
            end
          end
        end

        context 'with invalid attributes' do
          it 'with invalid attributes returns http unprocessable entity' do
            create_essay_submission(invalid_attributes, 0)

            assert_type_and_status(:unprocessable_entity)
          end
        end
      end

      context 'without access' do
        context 'essay item is free' do
          before { item.update(free: true) }

          it 'and valid attributes create a essay submission' do
            create_essay_submission(valid_attributes, 1)

            assert_apiv2_response(:created,
                                  EssaySubmission.last,
                                  V2::EssaySubmissionSerializer)
          end
        end

        context 'essay item is not free' do
          before { create_access.update(active: false) }
          it_should_behave_like 'unauthorized essay submission'
        end
      end
    end

    context 'as a teacher' do
      it_should_behave_like 'unauthorized essay submission'
    end

    context 'as a guest' do
      it_should_behave_like 'unauthorized essay submission'
    end
  end

  describe 'PUT #update' do
    context 'as admin' do
      before { authentication_headers_for(admin) }

      context 'with valid params' do
        context 'without essay marks' do
          it 'updates the requested essay_submission' do
            put :update, params: {
              id: essay_submission.token,
              essay: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAY'
            }

            assert_apiv2_response(:ok,
                                  essay_submission.reload,
                                  V2::EssaySubmissionSerializer,
                                  %i[correction_style user essay_marks])
          end

          it 'to valid status updates the requested essay_submission' do
            put :update, params: {
              id: essay_submission.token,
              essay: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAA',
              status: 'awaiting_correction'
            }

            assert_apiv2_response(:ok,
                                  essay_submission.reload,
                                  V2::EssaySubmissionSerializer,
                                  %i[correction_style user essay_marks])
          end
        end

        context 'with essay mark' do
          it 'updates the requested essay_submission' do
            expect do
              put :update, params: {
                id: essay_submission.token,
                essay_marks_attributes: [{ description: 'descrição',
                                           mark_type: 'ortografia',
                                           coordinate: { x: "1", y: "1" } }]
              }
            end.to change(EssayMark, :count).by(1)

            assert_apiv2_response(:ok,
                                  essay_submission.reload,
                                  V2::EssaySubmissionSerializer,
                                  %i[correction_style user essay_marks])
          end
        end

        context 'with uncorrectable status' do
          before { essay_submission.state_machine.transition_to(:awaiting_correction) }
          before { essay_submission.state_machine.transition_to(:correcting) }
          before { create_access.update(active: false) }
          it 'refunds one essay credit even if access has expired' do
            expect do
              put :update, params: {
                id: essay_submission.token,
                status: 'uncorrectable',
                uncorrectable_message: "title: description"
              }
            end.to change { create_expired_access.reload.essay_credits }.from(10).to(11)
            expect(parsed_response['data']['attributes']['status']).to eq("uncorrectable")
          end
        end

        context 'with essay correction check and essay submission grade' do
          it 'updates the requested essay_submission and create objects' do
            expect do
              put :update,\
                  params: { id: essay_submission.token,
                            essay_submission_grades_attributes: [{ grade: 200,
                                                                   correction_style_criteria_id: \
                                                                   correction_style_criteria.id }],
                            essay_correction_checks_attributes: [{
                              correction_style_criteria_check_id: \
                               correction_style_criteria_check.id,
                              checked: [100, 200]
                            }] }
            end.to change(EssayCorrectionCheck, :count).by(1).and\
              change(EssaySubmissionGrade, :count).by(1)

            assert_apiv2_response(:ok,
                                  essay_submission.reload,
                                  V2::EssaySubmissionSerializer,
                                  %i[correction_style user essay_marks
                                     essay_correction_checks essay_submission_grade])
          end
        end
      end

      context 'with invalid params' do
        it 'returns http unprocessable entity' do
          put :update, params: { id: essay_submission.token,
                                 status: 'corrected' }

          assert_type_and_status(:precondition_failed)
        end
      end
    end

    context 'as an user' do
      let(:valid_attributes) do
        { id: essay_submission.token, status: 'cancelled' }
      end

      context 'owner of essay' do
        before do
          authentication_headers_for(user)
        end

        it 'with valid params updates the requested essay_submission' do
          create_access

          put :update, params: valid_attributes

          assert_apiv2_response(:ok,
                                essay_submission.reload,
                                V2::EssaySubmissionSerializer,
                                %i[correction_style user essay_marks])
        end

        it 'with invalid params returns http unauthorized' do
          put :update, params: { id: essay_submission.token,
                                 status: 'correcting' }

          expect(response).to have_http_status(:unauthorized)
        end

        context 'rate essay_submission' do
          before do
            essay_submission.update(status: 4)
          end

          it 'updates rating of essay submission' do
            expect do
              put :update, params: { id: essay_submission.token, rating: 3 }
            end.to change { essay_submission.reload.rating }.from(0).to(3)
          end
        end
      end

      context 'another user' do
        let(:another_user) { create(:user) }
        before do
          authentication_headers_for(another_user)
        end

        it 'with valid params returns unathorized' do
          put :update, params: valid_attributes

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  def create_essay_submission(attributes, count)
    expect do
      post :create, params: attributes
    end.to change(EssaySubmission, :count).by(count)
  end

  def parsed_essay_submissions(collection)
    JSON.parse(to_jsonapi(collection,
                          EssaySubmissionSerializer,
                          %i[correction_style user]))
  end

  def assert_index_admin(results)
    assert_type_and_status(:success)
    results.each do |result|
      expect(parsed_response['data']).to include(
        parsed_essay_submissions(result)['data']
      )
    end
    expect(parsed_response).to include('links')
  end
end
