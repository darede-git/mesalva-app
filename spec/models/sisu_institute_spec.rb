# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SisuInstitute, type: :model do
  let!(:sisu_institute) do
    create(:sisu_institute, passing_score: '200,00')
  end
  let!(:sisu_institute2) do
    create(:sisu_institute, passing_score: '100,00')
  end

  context 'scopes' do
    context 'default_scope' do
      it 'returns sisu_institutes ordered by passing_score' do
        expect(SisuInstitute.all).to eq([sisu_institute2, sisu_institute])
      end
    end
    context.skip 'by_state_ies_modality_and_score' do
      it 'returns sisu institutes with weightings and scores' do
        state = 'CE'
        course = 'CIÊNCIA DA COMPUTAÇÃO'
        scores = { cnat: '600',
                   chum: '600',
                   ling: '650',
                   mat: '750',
                   red: '700' }
        fixture = YAML.load_file('spec/fixtures/sisu_user_scores.yml')
        response = [fixture['ufc'], fixture['ifce']]

        create_institutes_data

        ies = SisuInstitute.scores_by_state_ies(state, course, scores)

        expect(ies).to eq response
      end

      it 'returns sisu institutes with weightings and scores' do
        state = 'CE'
        course = 'CIÊNCIA DA COMPUTAÇÃO'
        modality = 'Ampla Concorrência'
        fixture = YAML.load_file('spec/fixtures/sisu_chances.yml')
        response = [fixture['ifce'], fixture['ufc']]

        create_institutes_data

        ies = SisuInstitute.chances_by_state_ies_modality(state,
                                                          course,
                                                          modality)
        expect(ies).to eq response
      end
    end
  end

  def create_institutes_data
    name = 'INSTITUTO FEDERAL DE EDUCAÇÃO, CIÊNCIA E TECNOLOGIA DO CEARÁ'
    create(:sisu_institute, year: '2021', ies: name, course: 'CIÊNCIA DA COMPUTAÇÃO',
                            grade: 'Bacharelado', shift: 'Integral',
                            modality: 'Ampla Concorrência', passing_score: '810,51',
                            state: 'CE', initials: 'IFCE', semester: '1')
    create(:sisu_weightings)

    name = 'UNIVERSIDADE FEDERAL DO CEARÁ'
    create(:sisu_institute, year: '2021', ies: name, course: 'CIÊNCIA DA COMPUTAÇÃO',
                            grade: 'Bacharelado', shift: 'Integral',
                            modality: 'Ampla Concorrência', passing_score: '641,02',
                            state: 'CE', initials: 'UFC', semester: '1')
  end
end
