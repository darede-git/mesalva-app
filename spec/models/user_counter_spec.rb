# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserCounter, type: :model do
  subject do
    described_class.new(user: user, period: Date.today.yday, period_type: :day)
  end

  it '#is valid' do
    expect(subject).to be_valid
  end

  context.skip '.increment_by_user_token' do
    context 'add by {medium_type: essay}' do
      context 'new user // no counters' do
        it 'it creates all periods counters increment current day counter' do
          expect do
            described_class.increment_by_user_token(user.token, 'essay')
          end.to change(described_class, :count).from(0).to(4)
          expect(described_class.user_date_period(user, :day).essay).to eq(1)
        end
      end
    end
  end
end
