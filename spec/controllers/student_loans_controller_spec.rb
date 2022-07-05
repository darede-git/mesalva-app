# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StudentLoansController, type: :controller do
  let(:default_serializer) { StudentLoanSerializer }

  describe "student loan " do
    context '#create' do
      before { admin_session }
      let(:package) { create(:package_valid_with_price) }
      let(:user) { create(:user) }
      context 'with price paid' do
        it 'returns created status' do
          post :create, params: { user_uid: user.uid, package_id: package.id,
                                  broker: 'koin', price_paid: 1000 }
          assert_type_and_status(:created)
        end
      end
      context 'without price paid' do
        it 'returns created status' do
          post :create, params: { user_uid: user.uid, package_id: package.id,
                                  broker: 'scholarship' }
          assert_type_and_status(:created)
        end
      end
      context 'with invalid broker' do
        it 'returns unprocessable entity' do
          post :create, params: { user_uid: user.uid, package_id: package.id,
                                  broker: 'invalid' }
          assert_type_and_status(:unprocessable_entity)
        end
      end
    end
  end
end
