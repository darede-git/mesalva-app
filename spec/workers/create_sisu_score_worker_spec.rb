# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateSisuScoreWorker do
  describe '#perform' do
    let(:form_submission) do
      entity = FactoryBot.build(:quiz_form_submission)
      entity.save(validate: false)
      entity
    end
    let(:user) { create(:user) }
    let(:fixture) { YAML.load_file('spec/fixtures/sisu_user_scores.yml') }
    let(:attributes) { [fixture['cefet']] }

    it 'creates a new sisu score' do
      expect do
        subject.perform(form_submission.id, user.id, attributes)
      end.to change(SisuScore, :count).by(1)
    end
  end
end
