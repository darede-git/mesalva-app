# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CrmRdstationObjectiveChangeEventWorker do
  describe '#perform' do
    let!(:user) { create(:user) }
    let!(:objective) { create(:objective) }

    before do
      event_study_objective_change = double
      expect(MeSalva::Crm::Rdstation::Event::StudyObjective).to receive(:new)
        .with({ user: user, objective_id: objective.id }).and_return(event_study_objective_change)
      expect(event_study_objective_change).to receive(:change)
    end

    it 'creates a rdstation study_objective_change event' do
      subject.perform(user.uid, objective.id)
    end
  end
end
