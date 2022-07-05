# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StudyPlan, type: :model do
  let(:study_plan) { create(:study_plan) }
  let(:study_plan_with_dinamic_dates) do
    create(:study_plan, :with_dinamic_dates)
  end

  before do
    create_list(:study_plan_node_module, 3,
                study_plan_id: study_plan.id, completed: true,
                updated_at: Time.now + 1.minute)
    create_list(:study_plan_node_module, 3,
                study_plan_id: study_plan.id, completed: true)
    create_list(:study_plan_node_module, 6,
                study_plan_id: study_plan.id, already_known: true)
    create_list(:study_plan_node_module, 10,
                study_plan_id: study_plan.id)
    create_list(:study_plan_node_module, 40,
                study_plan_id: study_plan_with_dinamic_dates.id)
  end
  context 'scopes' do
    context '#node_modules_count' do
      it 'returns total of node modules of a plan' do
        expect(study_plan.node_modules_count).to eq(22)
      end
    end
    context '#completed_node_modules_count' do
      it 'returns total of completed node modules of a plan' do
        expect(study_plan.completed_node_modules_count).to eq(6)
      end
    end
  end
  context 'validations' do
    should_be_present(:user)
    should_belong_to(:user)
    it { should have_many(:node_modules).through(:study_plan_node_modules) }
  end

  context 'setting module as already known' do
    it 'does not set module as completed' do
      study_plan_node_module = study_plan.study_plan_node_modules
                                         .where('completed is false')
                                         .order(:id)
                                         .first
      study_plan_node_module.update(already_known: true)

      expect(study_plan_node_module.reload.completed).to be_falsey
    end
  end

  describe '#current_week_completed_modules' do
    it 'returns a list of modules with the completion date and total' do
      current_week_modules = study_plan.current_week_completed_modules
      module_names = study_plan.node_modules.pluck(:name)
      current_date = Time.now.strftime('%d/%m/%Y')

      expect(current_week_modules.first['name']).to eq(module_names.first)
      expect(current_week_modules.first['completed_at']).to eq(current_date)
      expect(current_week_modules.last['name']).to eq(module_names[2])
      expect(current_week_modules.last['completed_at']).to eq(current_date)
      expect(current_week_modules.last['total']).to eq(3)
    end
  end

  describe '#modules_per_week' do
    let(:end_date) { Time.now + 12.week }

    context 'end date on beginning of week' do
      before do
        study_plan_with_dinamic_dates
          .update_attributes(end_date: end_date.beginning_of_week)
      end

      context 'when alredy start' do
        it 'returns modules per week using current data' do
          expect(study_plan_with_dinamic_dates.modules_per_week).to eq(4)
        end
      end

      context 'when not started' do
        before do
          study_plan_with_dinamic_dates
            .update_attributes(start_date: Time.now + 4.week)
        end

        it 'returns modules per week using start at' do
          expect(study_plan_with_dinamic_dates.modules_per_week).to eq(5)
        end
      end
    end

    context 'end date on end of week' do
      before do
        study_plan_with_dinamic_dates
          .update_attributes(end_date: end_date.end_of_week)
      end

      context 'when alredy start' do
        it 'returns modules per week using current data' do
          expect(study_plan_with_dinamic_dates.modules_per_week).to eq(4)
        end
      end

      context 'when not started' do
        before do
          study_plan_with_dinamic_dates
            .update_attributes(start_date: Time.now + 4.week)
        end

        it 'returns modules per week using start at' do
          expect(study_plan_with_dinamic_dates.modules_per_week).to eq(5)
        end
      end
    end

    context 'when the current date is greater than the end date' do
      before do
        study_plan_with_dinamic_dates
          .update_attributes(end_date: (Time.now - 1.day))
      end

      it 'return 0 modules per week' do
        expect(study_plan_with_dinamic_dates.modules_per_week).to eq(0)
      end
    end
  end
end
