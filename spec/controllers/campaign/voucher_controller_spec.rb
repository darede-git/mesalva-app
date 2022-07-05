# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Campaign::VoucherController, type: :controller do
  describe 'POST #create' do
    it_behaves_like 'a unauthorized create route for', %w[admin guest]

    context 'as user' do
      before { user_session }

      let(:user2) { create(:user) }
      let!(:voucher) { create(:voucher, user: user2) }

      context 'valid attributes' do
        it 'returns http created' do
          expect do
            post :create, params: { token: voucher.token }
          end.to change(Access, :count)
            .by(1)
            .and change(ActionMailer::Base.deliveries, :count)
            .by(1)

          assert_type_and_status(:created)
          voucher.reload
          expect(voucher.active).to eq(false)
          expect(parsed_response['meta']).to include('created-by')
        end
      end

      context 'invalid attributes' do
        context 'same user' do
          before { voucher.update(user: user) }

          it 'returns http unprocessable entity' do
            expect do
              post :create, params: { token: voucher.token }
            end.to change(Access, :count).by(0)

            assert_type_and_status(:unprocessable_entity)
          end
        end

        context 'invalid token' do
          it 'returns http unprocessable entity' do
            expect do
              post :create, params: { token: 'invalid_token' }
            end.to change(Access, :count).by(0)

            assert_type_and_status(:unprocessable_entity)
          end
        end

        context 'coupon inactive' do
          before { voucher.update(active: false) }

          it 'returns http unprocessable entity' do
            expect do
              post :create, params: { token: voucher.token }
            end.to change(Access, :count).by(0)

            assert_type_and_status(:unprocessable_entity)
          end
        end

        context 'coupon expired' do
          let(:created_at) do
            Time.now - (ENV['VOUCHER_DURATION_DAYS'].to_i + 1).days
          end
          before { voucher.update(created_at: created_at) }

          it 'returns http unprocessable entity' do
            expect do
              post :create, params: { token: voucher.token }
            end.to change(Access, :count).by(0)

            assert_type_and_status(:unprocessable_entity)
          end
        end
      end
    end
  end
end
