# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendVoucherEmailWorker do
  context 'valid attributes' do
    let(:platform) { create(:platform) }
    let(:platform_voucher) do
      create(:platform_voucher,
             :already_in_use, platform_id: platform.id)
    end
    it 'send a email with platform domain' do
      platform_voucher.update(email: user.email)
      expect do
        subject.perform(platform_voucher.token)
      end.to change(ActionMailer::Base.deliveries, :count).by(1)
      expect(ActionMailer::Base.deliveries.last.to.first).to eq(user.email)
      expect(ActionMailer::Base.deliveries.last.from.first).to \
        eq("naoresponda@plataforma.ms")
    end
  end
end
