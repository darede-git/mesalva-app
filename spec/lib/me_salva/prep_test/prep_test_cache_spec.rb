# frozen_string_literal: true

require 'rails_helper'

describe MeSalva::PrepTest::PrepTestCache do
  let(:subject) { MeSalva::PrepTest::PrepTestCache.new(submission_token) }
  let(:score) { 312.87 }
  let(:answers) { %w[answer1 answer2] }
  let(:permalink_slug) { "node/nodemodule/item/medium1" }
  let(:submission_token) { "submission_token_example" }
  let(:user_uid) { "darth@vabor.molvania" }

  before do
    @meta = { 'score': score, answers: answers }
    @user_uid = user_uid
  end

  context '#add' do
    let(:permalink) { create(:permalink, :ends_with_medium) }
    before do
      subject.add(permalink, true)
    end
    context 'then #save' do
      it 'calls overview worker' do
        expect(PrepTestOverviewWorker).to receive(:perform_async).with(
          score: score,
          answers: answers,
          token: submission_token,
          user_uid: @user_uid,
          permalink_slug: 'permalink',
          corrects: 1
        ).once
        subject.save(@meta, user_uid)
      end

      it 'calls detail worker' do
        expect(PrepTestDetailWorker).to receive(:perform_async).once
        subject.save(@meta, @user_uid)
      end
    end
  end

  context '#save with no #add' do
    it 'does not calls save workers' do
      expect(PrepTestOverviewWorker).not_to receive(:perform_async)
      expect(PrepTestDetailWorker).not_to receive(:perform_async)
      subject.save(@meta, @user_uid)
    end
  end
end
