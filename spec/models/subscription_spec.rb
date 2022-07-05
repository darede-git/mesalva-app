# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  context 'validations' do
    should_be_present(:user)
    it { should validate_uniqueness_of :token }
  end

  context 'scopes' do
    describe '.find_by_token_and_user_id' do
      it 'returns the subscription by its token and user' do
        user = create(:user)
        subs = create_list(:subscription, 2, user: user)
               .first
        expect(Subscription.find_by_token_and_user_id(subs.token, user.id))
          .to eq(subs)
      end
    end
  end
end
