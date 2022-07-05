# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::StudyPlansController, type: :controller do
  let(:study_plan) do
    create(:study_plan,
           user_id: user.id,
           limit: 24)
  end
  let(:study_plan_node_modules) do
    create_list(:study_plan_node_module,
                118,
                study_plan: study_plan)
  end
  let(:included_study_plan_node_module) do
    node_module = StudyPlanNodeModule.where(study_plan_id: study_plan.id)
                                     .first
    study_plan_node_module_data(node_module)
  end
  let(:meta_response) do
    { 'modules-count' => 118,
      'completed-modules-count' => 0,
      'current-week-completed-modules-count' => 0,
      'limit' => 24,
      'offset' => 0,
      'total-pages' => 5 }
  end
  let(:current_day_mock) do
    Time.parse('15/10/2017')
  end

  describe "GET #show" do
    context 'as a guest' do
      it 'returns unauthorized' do
        get :show
        assert_status_response(:unauthorized)
      end
    end

    context 'as an admin' do
      before { build_session('admin') }
      it 'returns unauthorized' do
        get :show
        assert_status_response(:unauthorized)
      end
    end

    context 'as user' do
      before do
        build_session('user')
      end

      context 'user has no study_plans' do
        it 'returns not found' do
          get :show
          assert_type_and_status(:not_found)
        end
      end

      context 'user has study_plans' do
        context 'when limit is 0' do
          before do
            study_plan.update(limit: 0)
          end

          it "returns user's last study_plan without node modules" do
            get :show

            expect(parsed_response['included'].count).to eq(0)
            assert_study_plan_data(0)
            expect(response.headers['Links'])
              .to eq('first' => 'http://test.host/user/study_plans?page=1',
                     'last' => 'http://test.host/user/study_plans?page=1',
                     'self' => 'http://test.host/user/study_plans')
          end
        end

        context 'and a few modules' do
          before do
            study_plan_node_modules
            node_area_subject = create(:node_area_subject,
                                       name: 'Materias')
            add_permalink_to_all_node_modules(node_area_subject)
          end

          context 'and access to study_plan related packages' do
            let(:package_valid) do
              create(:package_valid_with_price, :study_plan)
            end
            let!(:access_valid) do
              create(:access_with_expires_at, package_id: package_valid.id,
                                              user_id: user.id)
            end

            before do
              Timecop.freeze(current_day_mock)
              allow_any_instance_of(StudyPlan).to receive(:updated_at)
                .and_return(current_day_mock)
            end

            it "returns user's last study_plan" do
              get :show

              assert_type_and_status(:ok)
              assert_study_plan_response
            end
          end

          context 'but no access to study plan related packages' do
            before do
              Timecop.freeze(current_day_mock)
              allow_any_instance_of(StudyPlan).to receive(:updated_at)
                .and_return(current_day_mock)
            end

            it "returns user's last study_plan" do
              get :show

              assert_type_and_status(:ok)
              assert_study_plan_response
            end
          end
        end

        context 'and modules for pagination' do
          before do
            study_plan_node_modules
            node_area_subject = create(:node_area_subject,
                                       name: 'Materias')
            add_permalink_to_all_node_modules(node_area_subject)
          end
          context 'forward pagination' do
            context 'when a valid page param is informed' do
              it 'returns the page results' do
                get :show, params: { page: 5 }

                expect(parsed_response['included'].count).to eq(22)
                assert_study_plan_data(22)
                expect(response.headers['Links'])
                  .to eq('first' => 'http://test.host/user/study_plans?page=1',
                         'last' => 'http://test.host/user/study_plans?page=5',
                         'prev' => 'http://test.host/user/study_plans?page=4',
                         'self' => 'http://test.host/user/study_plans?page=5')
              end
            end
          end

          context 'backward pagination' do
            context 'when a valid page param is informed' do
              before do
                study_plan.offset = 97
                study_plan.save
              end
              after do
                study_plan.offset = 0
                study_plan.save
              end

              it 'returns the page results' do
                get :show, params: { page: -2 }

                expect(parsed_response['included'].count).to eq(24)
                assert_study_plan_data(24)
                expect(response.headers['Links'])
                  .to eq('first' => 'http://test.host/user/study_plans?page=-4',
                         'last' => 'http://test.host/user/study_plans?page=1',
                         'next' => 'http://test.host/user/study_plans?page=-1',
                         'prev' => 'http://test.host/user/study_plans?page=-3',
                         'self' => 'http://test.host/user/study_plans?page=-2')
              end
            end
          end

          context 'when an out of range page param is informed' do
            let(:empty_response) do
              {
                'data' => {
                  'id' => study_plan.id.to_s,
                  'type' => 'study-plan',
                  'attributes' => {
                    'id' => study_plan.id,
                    'shifts' => [{ '0' => 'mid' }],
                    'start-date' => '2017-09-28T12:53:54.000Z',
                    'end-date' => '2017-10-28T12:53:54.000Z',
                    'available-time' => 12
                  },
                  'relationships' => {
                    'user' => {
                      'data' => {
                        'id' => user.id.to_s, 'type' => 'user'
                      }
                    }, 'study-plan-node-modules' => {
                      'data' => []
                    }
                  }
                },
                'meta' => {
                  'modules-count' => 118,
                  'offset' => 0,
                  'limit' => 24,
                  'completed-modules-count' => 0,
                  'current-week-completed-modules-count' => 0,
                  'total-pages' => 5
                },
                'included' => []
              }
            end
            it 'returns a page with no results' do
              get :show, params: { page: 6 }

              expect(parsed_response).to eq(empty_response)
            end
          end
        end
      end
    end
  end

  describe 'POST #create' do
    let(:answers) do
      { shifts: [{ '0' => 'morning' }, { '0' => 'mid' }],
        end_date: (DateTime.now + 1.month).to_s,
        subject_ids: [1280, 1224, 1190, 1166, 1090, 994],
        keep_completed_modules: false }
    end
    let(:structure_attrs) do
      { user_id: user.id }
        .merge(answers)
    end

    context 'as a guest' do
      it 'returns unauthorized' do
        post :create, params: answers
        assert_status_response(:unauthorized)
      end
    end

    context 'as an admin' do
      before { build_session('admin') }
      it 'returns unauthorized' do
        post :create, params: answers
        assert_status_response(:unauthorized)
      end
    end

    context 'as an user' do
      before { build_session('user') }

      context 'invalid answers' do
        it 'returns http code 422 unprocessable_entity' do
          answers = { subject_ids: [],
                      shifts: [{ '1' => 'mid', '2' => 'morning' }],
                      keep_completed_modules: true }

          post :create, params: answers

          assert_type_and_status(:unprocessable_entity)
          expect(parsed_response)
            .to eq('errors' => [['Answer subject_ids is not present',
                                 'Answer end_date is not present']])

          expect(StudyPlanStructureWorker)
            .not_to receive(:perform_async).with(any_args)
        end
      end

      context 'valid answers' do
        before do
          allow(MeSalva::StudyPlan::Structure).to receive(:new)
            .with(structure_attrs)
            .and_return(double(valid?: true, build: true))
        end
        it 'returns http code 204' do
          expect(StudyPlanStructureWorker)
            .to receive(:perform_async).with(structure_attrs.to_json)

          post :create, params: answers

          expect(response).to have_http_status(:no_content)
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'study plan deactivation' do
      before { build_session('user') }

      let!(:study_plan) { create(:study_plan, user_id: user.id, active: true) }

      context 'study plan exists' do
        it 'sets study plan active to false' do
          put :update, params: { id: study_plan.id, active: false }

          expect(study_plan.reload.active).to be_falsey
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'study plan does not exist' do
        it 'returns not found' do
          put :update, params: { id: 999, active: false }

          assert_type_and_status(:not_found)
        end
      end

      context 'study plan belongs to another user' do
        let(:another_user) { create(:user) }
        let(:another_study_plan) { create(:study_plan, user: another_user) }

        it 'returns unauthorized' do
          put :update, params: { id: another_study_plan.id, active: false }

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  def study_plan_node_module_data(study_plan_node_module)
    instance_for(study_plan_node_module)
    { 'id' => @module.id.to_s,
      'type' => 'study-plan-node-module',
      'attributes' => { 'node-module' => module_name,
                        'completed' => false,
                        'already-known' => false,
                        'subject' => subject_name,
                        'permalink' => permalink_slug,
                        'position' => @module.position } }
  end

  def add_permalink_to_all_node_modules(_parent_node)
    NodeModule.all.each do |node_module|
      node = create(:node)
      node_area_subject = create(:node_area_subject,
                                 name: 'Materias')
      create(:permalink,
             slug: "#{node.slug}/#{node_area_subject.slug}/#{node_module.slug}",
             node_module_id: node_module.id,
             nodes: [node, node_area_subject])
    end
  end

  def instance_for(study_plan_node_module)
    @module = study_plan_node_module
  end

  def module_name
    @module.node_module.name
  end

  def subject_name
    { 'color-hex' => nil, 'name' => module_first_permalink.nodes.last.name }
  end

  def permalink_slug
    module_first_permalink.slug
  end

  def module_first_permalink
    @module.node_module.permalinks.first
  end

  def assert_study_plan_response
    assert_study_plan_data
    assert_study_plan_included(24, included_study_plan_node_module)
    expect(parsed_response['meta']).to eq(meta_response)
    expect(response.headers['Links'])
      .to eq('first' => 'http://test.host/user/study_plans?page=1',
             'last' => 'http://test.host/user/study_plans?page=5',
             'next' => 'http://test.host/user/study_plans?page=2',
             'self' => 'http://test.host/user/study_plans')
  end

  def assert_study_plan_data(count = 24)
    relationships = parsed_response['data']['relationships']
    expect(relationships.keys)
      .to eq %w[user study-plan-node-modules]
    expect(
      relationships['study-plan-node-modules']['data'].count
    ).to eq(count)
  end

  def assert_study_plan_included(count, node_module)
    expect(parsed_response['included'].count).to eq(count)
    expect(parsed_response['included'].first).to \
      eq(node_module)
  end
end
