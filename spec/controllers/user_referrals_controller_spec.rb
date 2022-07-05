# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserReferralsController, type: :controller do
  before do
    user_session
    ENV['REFERRAL_INTERVAL_IN_HOURS'] = '2'
  end

  context '#index' do
    context 'user has no referral' do
      it 'creates and shows the user referral as created' do
        expect { get :index }.to change(UserReferral, :count).by(1)

        expect(response).to have_http_status(:created)
      end

      it 'calls the counting worker' do
        expect(UserReferralCounterWorker).not_to receive(:perform_async)

        get :index
      end
    end

    context 'user has referral and check has not been done yet' do
      let!(:user_referral) do
        create(:user_referral,
               user_id: user.id,
               last_checked: nil)
      end

      it 'shows the user key' do
        get :index

        expect(parsed_response['data']['id']).to eq(user.token)
      end

      it 'returns partial content as response' do
        get :index

        expect(response).to have_http_status(:partial_content)
      end
    end

    context 'user has referral and check has already been done' do
      let!(:user_referral) do
        create(:user_referral,
               user_id: user.id,
               last_checked: Time.now)
      end

      it 'returns the referral with status :ok' do
        get :index

        expect(response).to have_http_status(:ok)
      end

      it 'does not call the counter worker' do
        expect(
          UserReferralCounterWorker
        ).not_to receive(:perform_async).with(user.token)

        get :index
      end

      context 'but after waiting' do
        it 'user can check referrals again' do
          user_referral.update(
            last_checked: Time.now -
              ENV['REFERRAL_INTERVAL_IN_HOURS'].to_i.hours - 5.minute
          )

          expect(
            UserReferralCounterWorker
          ).to receive(:perform_async).with(user.token)
          get :index
        end
      end
    end
  end
end
