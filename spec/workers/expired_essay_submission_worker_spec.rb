# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpiredEssaySubmissionWorker do
  describe '#perform' do
    subject { described_class.new }
    let!(:access) { create(:access_with_duration_and_node, user: user) }
    let!(:essay_submission) { create(:essay_submission_with_essay, user: user) }

    before do
      essay_submission.state_machine.transition_to!(:correcting)
      essay_submission.update(updated_at: (Time.now - 122.minutes))
    end

    it 'transits expired essays to awaiting correction' do
      expect do
        subject.perform
      end.to change { essay_submission.reload.status }.from(2).to(1)
    end
  end
end
