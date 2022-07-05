# frozen_string_literal: true

require 'rails_helper'

describe MeSalva::Event::User::Content::StudyPlan do
  subject { described_class.new(user) }

  describe '.counters' do
    let!(:study_plan) { create(:study_plan, user: user) }
    let(:updated_at) { Time.now.beginning_of_week - 1.day }

    before do
      create(:study_plan_node_module, study_plan: study_plan, completed: true,
                                      updated_at: Time.now + 1.minute)
      create(:study_plan_node_module, study_plan: study_plan, completed: false)
      create(:study_plan_node_module, study_plan: study_plan, completed: true,
                                      updated_at: updated_at)
    end

    it 'returns study plan consumption counters' do
      expect(subject.counters).to eq('week' => { 'modules-count' => 1 })
    end
  end
end
