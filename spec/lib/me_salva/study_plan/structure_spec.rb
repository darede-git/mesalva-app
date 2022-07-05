# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/permalinks/builder'

describe MeSalva::StudyPlan::Structure do
  include StudyPlanHelper

  subject do
    shifts = [{ 0 => :mid }, { 0 => :evening }]
    subject_ids = [1280, 1224, 1190, 1166, 1090, 994]
    end_date = (DateTime.now + 1.month).to_s
    MeSalva::StudyPlan::Structure
      .new(user_id: user.id,
           shifts: shifts,
           end_date: end_date,
           subject_ids: subject_ids,
           keep_completed_modules: true)
  end

  let(:previous_study_plan_completed_node_modules) do
    [92, 104, 774, 560, 463, 776, 208]
  end

  let(:previous_study_plan_node_modules) do
    previous_study_plan_completed_node_modules + \
      [723, 68, 91, 713, 48]
  end

  describe '#valid?' do
    context 'invalid answers' do
      it 'returns false' do
        expect(missing_answers.valid?).to be_falsey
      end
    end
  end

  describe '#errors' do
    context 'invalid answers' do
      it 'returns a list of errors' do
        expect(missing_answers.errors)
          .to eq(['Answer subject_ids is not present',
                  'Answer end_date is not present'])
      end
    end
  end

  describe '#build' do
    context 'student has a valid access' do
      before do
        Timecop.freeze("2019-02-27 11:51:47 -0300")

        create_user_acessible_modules

        allow(StudyPlanNodeModule)
          .to receive(:by_user_subjects)
          .and_return(accessible_modules)
      end

      context 'previous study plan does not exist' do
        before { mock_keep_completed_modules_with(false) }
        it_behaves_like 'a default study plan from form submission', :full
      end

      context 'previous study plan exists' do
        let!(:previous_study_plan) do
          create(:study_plan, user_id: user.id, active: true)
        end

        it 'disables all previous study plans' do
          subject.build
          new_study_plan = StudyPlan.last

          expect(new_study_plan.active).to eq(true)
          expect(previous_study_plan.reload.active).to eq(false)
        end

        context 'keeping previous modules as completed' do
          before do
            mock_keep_completed_modules_with(true)
          end

          context 'previous study plan has completed modules' do
            before do
              study_plan = StudyPlan.first
              complete_modules_for(study_plan)
            end

            it 'generates a study plan including previously '\
              'completed node modules as completed' do
              expect do
                subject.build
              end.to change(StudyPlan, :count)
                .by(1).and change(StudyPlanNodeModule, :count).by(27)

              expect(StudyPlan.last.node_modules.completed.count).to eq(7)
              expect(StudyPlan.last.start_date.to_date.to_s)
                .to eq('2019-02-27')
              expect(StudyPlan.last.end_date.to_date.to_s).to eq "2019-03-27"
            end
            context 'after generation' do
              before do
                subject.build
              end
              let(:last_study_plan) { StudyPlan.last }

              it 'keep previous completed modules as completed' do
                expect(last_study_plan
                         .study_plan_node_modules
                         .first(7)
                         .map(&:completed)
                         .uniq)
                  .to eq([true])
              end
              it 'sets the offset to first not completed module position' do
                expect(last_study_plan.offset).to eq(7)
              end
            end
          end
        end

        context 'dont keeping previous modules as completed '\
                'with previous study plan has completed modules' do
          before do
            mock_keep_completed_modules_with(false)
            study_plan = StudyPlan.first
            study_plan.node_module_ids = previous_study_plan_node_modules

            study_plan
              .study_plan_node_modules
              .where(
                node_module_id: previous_study_plan_completed_node_modules
              ).update_all(completed: true)
          end

          let(:previous_study_plan_node_modules) do
            previous_study_plan_completed_node_modules + \
              [723, 68, 91, 713, 48]
          end

          let(:previous_study_plan_completed_node_modules) do
            [92, 104, 774, 560, 463, 776, 208]
          end

          it_behaves_like 'a default study plan from form submission', :full
        end
      end

      context 'previous study plan has no completed modules' do
        before { mock_keep_completed_modules_with(false) }
        it_behaves_like 'a default study plan from form submission', :full
      end
    end
  end

  describe '#maintenance' do
    context 'study_plan does not exists' do
      it 'raises an error' do
        expect do
          MeSalva::StudyPlan::Structure.new(study_plan_id: 999)
                                       .maintenance
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'active study plan' do
      context 'when the pending modules are less than the number of weeks' do
        it 'updates study plan offset and set modules count as the limit' do
          create_user_acessible_modules
          study_plan = create(:study_plan,
                              :with_dinamic_dates,
                              user_id: user.id,
                              active: true)
          complete_modules_for(study_plan)

          MeSalva::StudyPlan::Structure.new(study_plan_id: study_plan.id)
                                       .maintenance

          study_plan.reload
          expect(study_plan.offset).to eq(7)
          expect(study_plan.limit).to eq(5)
        end
      end
    end
  end

  def complete_modules_for(study_plan)
    study_plan.node_module_ids = previous_study_plan_node_modules

    study_plan
      .study_plan_node_modules
      .where(node_module_id: previous_study_plan_completed_node_modules)
      .update_all(completed: true)
  end

  def create_user_acessible_modules
    accessible_modules.map { |i| create(:node_module, id: i[:node_module_id]) }
  end

  def missing_answers
    subject_ids = []
    shifts = { 1 => :mid, 2 => :morning }
    MeSalva::StudyPlan::Structure.new(subject_ids: subject_ids,
                                      shifts: shifts,
                                      keep_completed_modules: true)
  end
end
