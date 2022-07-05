# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PendingEssayEventWorker do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:essay1) do
    create(:essay_submission,
           created_at: Time.now - 2.day,
           user_id: user.id)
  end
  let!(:essay2) do
    create(:essay_submission,
           created_at: Time.now - 1.day,
           user_id: user.id)
  end
  let!(:essay3) do
    create(:essay_submission,
           created_at: Time.now,
           user_id: other_user.id)
  end

  describe '#perform' do
    subject { described_class.new }

    context 'valid params' do
      it 'should create a notification for this user but not for other_user' do
        expect { subject.perform }.to change(Notification, :count).by(1)
      end
    end
  end
end
