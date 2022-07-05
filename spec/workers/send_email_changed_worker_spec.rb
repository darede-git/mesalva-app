# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendEmailChangedWorker do
  context 'perform with platform_slug' do
    it 'send a email with custom from' do
      expect do
        subject.perform(user_platform.user.token, user_platform.platform.slug)
      end.to change(ActionMailer::Base.deliveries, :count).by(1)
      expect(ActionMailer::Base.deliveries.last.to.first).to eq("new-#{user_platform.user.email}")
      expect(ActionMailer::Base.deliveries.last.from.first).to \
        eq(ENV['MAIL_SENDER'])
    end
  end
  context 'perform with mesalva user' do
    it 'send a email with default from' do
      expect do
        subject.perform(user.token, nil)
      end.to change(ActionMailer::Base.deliveries, :count).by(1)
      expect(ActionMailer::Base.deliveries.last.to.first).to eq("new-#{user.email}")
      expect(ActionMailer::Base.deliveries.last.from.first).to \
        eq(ENV['MAIL_SENDER'])
    end
  end
  context 'perform with mesalva user but with platform_slug' do
    it 'raise an error' do
      expect do
        subject.perform(user.token, user_platform.platform.slug)
      end.to raise_error(NoMethodError)
    end
  end
end
