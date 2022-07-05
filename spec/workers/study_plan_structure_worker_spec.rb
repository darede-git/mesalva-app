# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StudyPlanStructureWorker do
  describe '#perform' do
    subject { described_class.new }
    context 'valid params' do
      it 'should call the study plan builder' do
        attrs = { user_id: 1,
                  subject_ids: [1280, 1224, 1190, 1166, 1090, 994],
                  shifts: [{ 1 => :mid }, { 2 => :morning }],
                  end_date: (DateTime.now + 1.month).to_s,
                  keep_completed_modules: true }
        stub_const('MeSalva::StudyPlan::Structure', double)
        allow(MeSalva::StudyPlan::Structure).to receive(:new)
          .with(attrs)
          .and_return(double(build: true))

        expect(subject.perform(attrs.to_json)).to be_truthy
      end
    end
  end
end
