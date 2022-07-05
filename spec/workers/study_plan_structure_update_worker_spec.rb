# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StudyPlanStructureUpdateWorker do
  describe '#perform' do
    subject { described_class.new }

    context 'valid params' do
      it 'should call study plan structure update method for active plans' do
        stub_const('MeSalva::StudyPlan::Structure', double)
        allow(MeSalva::StudyPlan::Structure).to receive(:new)
          .with(study_plan_id: 1)
          .and_return(double(maintenance: true))

        expect(subject.perform).to be_truthy
      end
    end
  end
end
