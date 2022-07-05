# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/permalinks/builder'

RSpec.describe StudyPlanNodeModule, type: :model do
  include PermalinkBuildingHelper
  include StudyPlanNodeModuleHelper

  before(:all) { Node.destroy_all }
  before(:all) { NodeModule.destroy_all }

  after :all do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  context 'validations' do
    should_belong_to(:study_plan, :node_module)
    should_be_present(:study_plan, :node_module)
    it do
      should validate_inclusion_of(:shift).in_array(%w[morning mid evening])
      should validate_inclusion_of(:weekday).in_array(%w[sunday monday tuesday
                                                         wednesday thursday
                                                         friday saturday])
    end
  end

  context 'scopes' do
    context 'by_user_subjects' do
      let(:user) { create(:user) }
      let(:node_subject) do
        create(:node_subject, id: ENV['STUDY_PLAN_TOP_NODE_ID'],
                              name: 'Materias')
      end
      let!(:education_segment) { create(:node) }
      let(:node_1) { create(:node) }
      let(:node_2) { create(:node) }
      let!(:node_modules) do
        create_list(:node_module, 18, nodes: [node_1])
      end
      let!(:node_module_not_included) do
        create(:node_module, nodes: [node_2])
      end
      let(:package) do
        create(:package_with_duration, :study_plan, nodes: [node_1])
      end
      let!(:access_valid) do
        create(:access_with_expires_at, package_id: package.id,
                                        user_id: user.id)
      end

      before do
        node_subject.update(parent: education_segment)
        node_1.update(parent: node_subject)
        node_2.update(parent: node_subject)
        build_permalinks(education_segment, :subtree)
      end

      it 'returns acessible modules with relevancy and hours duration' do
        user_modules = StudyPlanNodeModule.by_user_subjects(user.id,
                                                            [node_subject.id])
        expect(user_modules.length).to eq(18)
        expect(user_modules.first)
          .to eq('node_module_id' => first_node_module_id.to_i,
                 'relevancy' => 1,
                 'subject_id' => 992,
                 'hours_duration' => '1')
        expect(user_modules.last)
          .to eq('node_module_id' => last_node_module_id.to_i,
                 'relevancy' => 1,
                 'subject_id' => 992,
                 'hours_duration' => '1')
        study_plan_node_modules = user_modules.map { |um| um['node_module_id'] }
        expect(study_plan_node_modules)
          .not_to include(node_module_not_included.id)
      end
    end
  end
end
