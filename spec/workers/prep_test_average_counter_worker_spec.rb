# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrepTestAverageCounterWorker do
  context 'perform' do
    let!(:prep_test) do
      create(:prep_test, permalink_slug: 'slug/humanas')
    end
    let!(:permalink_event_prep_test) do
      create(
        :permalink_event_prep_test,
        id: 99_000_001,
        submission_token: 'token'
      )
    end
    let!(:prep_test_score) do
      create(:prep_test_score,
             submission_token: 'token',
             permalink_slug: 'slug/humanas',
             prep_test_id: prep_test.id)
    end
    it 'counts the averages of every preptest submission' do
      subject.perform(prep_test.id)

      expect(prep_test.reload.chum_min_score).to eq(prep_test_score.score)
      expect(prep_test.reload.chum_average_score).to eq(prep_test_score.score)
      expect(prep_test.reload.chum_max_score).to eq(prep_test_score.score)
      expect(prep_test.reload.chum_average_correct).to eq(1)
    end
  end
end
