# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/sisu/scores'

describe MeSalva::Sisu::Scores do
  let(:entity) do
    load('db/seeds/production/3-sisu.seeds.rb')
    Quiz::Form.find(4)
  end
  let(:form_submission) do
    create(:quiz_form_submission_with_answers, form: entity)
  end
  let(:fixture) { YAML.load_file('spec/fixtures/sisu_user_scores.yml') }

  describe.skip '#results' do
    before do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[])
        .with('QUIZ_FORM_STUDY_PLAN_IDS').and_return("[10,20,30,40,50]")

      create(:sisu_institute, state: 'AC')

      form_submission.answers = []
      create_answer(entity.questions[0], entity.questions[0].alternatives[0])
      create_answer(entity.questions[1], entity.questions[1].alternatives[0])
      create_answer(entity.questions[2], entity.questions[2].alternatives[0])
      create_answer(entity.questions[3], nil, '500')
      create_answer(entity.questions[4], nil, '500')
      create_answer(entity.questions[5], nil, '500')
      create_answer(entity.questions[6], nil, '500')
      create_answer(entity.questions[7], nil, '500')
      form_submission.answers.reload

      expect(CreateSisuScoreWorker)
        .to receive(:perform_async)
        .with(form_submission.id,
              user.id,
              [fixture['cefet']])
    end

    subject do
      MeSalva::Sisu::Scores.new(form_submission, user.id)
    end

    it 'returns user scores' do
      expect(subject.results)
        .to eq(scores: [fixture['cefet']],
               max_passing_score: 674.24,
               max_average: 500.0,
               min_passing_score: 674.24,
               min_average: 500.0)
    end
  end

  def create_answer(question, alternative, value = nil)
    create(:quiz_answer,
           form_submission: form_submission,
           question: question,
           alternative: alternative,
           value: value)
  end
end
