# frozen_string_literal: true

require 'spec_helper'

describe MeSalva::Crm::Rdstation::Event::StudyObjective do
  describe '#studyobjective' do
    context 'for study_objective_change event' do
      let!(:objective1) { create(:objective, name: 'Estudar para o ensino fundamental') }
      event_name = "study_objective_change"
      let(:default_attributes1) { { cf_objetivo_de_estudos: objective1.name } }
      context 'through sender class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Sender.new(event: event_name.to_sym,
                                                     params: { user: user,
                                                               objective_id: objective1.id })
        end
        before do
          expect_study_objective_change_in_rd(default_attributes1)
        end

        it 'creates rdstation study_objective_change event' do
          subject.send_event
        end
      end
      context 'direct from study_objective class' do
        let!(:objective2) { create(:objective, name: 'Reforço Escolar para o Ensino Médio') }
        let(:default_attributes2) { { cf_objetivo_de_estudos: objective2.name } }
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::StudyObjective.new({ user: user,
                                                               objective_id: objective2.id })
        end
        before do
          expect_study_objective_change_in_rd(default_attributes2)
        end

        it 'creates rdstation study_objective_change event' do
          subject.change
        end
      end
    end
  end

  def expect_study_objective_change_in_rd(attributes)
    client = double
    expect(MeSalva::Crm::Rdstation::Event::Client).to receive(:new)
      .with({ user: user,
              event_name: 'mudanca-de-objetivo-de-estudos',
              payload: attributes })
      .and_return(client)
    expect(client).to receive(:create)
  end
end
