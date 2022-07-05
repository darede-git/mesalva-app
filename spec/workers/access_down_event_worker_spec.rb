# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccessDownEventWorker do
  let!(:user) { create(:user) }
  let!(:access) do
    create(:access_with_duration_and_node,
           expires_at: Time.now + 1.minute, user: user)
  end

  let!(:access2) do
    create(:access_with_duration_and_node,
           expires_at: Time.now + 1.day, user: user)
  end

  let!(:access3) do
    create(:access_with_duration_and_node,
           expires_at: Time.now + 3.day, user: user)
  end

  describe '#perform' do
    it 'updates user intercom subscriber attributes' do
      expect(UpdateIntercomUserWorker).to receive(:perform_async)
      expect(CreateIntercomEventWorker).to receive(:perform_async)
      expect(PersistCrmEventWorker).to receive(:perform_async)

      subject.perform
    end
  end
end
