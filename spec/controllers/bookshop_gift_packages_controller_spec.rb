# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookshopGiftPackagesController, type: :controller do
  describe '#index' do
    context 'as user admin' do
      before { admin_session }
      context 'bookshop gift packages found' do
        let!(:package) do
          create(:package_valid_with_price)
        end
        let!(:bookshop_gift_package) do
          create(:bookshop_gift_package, package_id: package.id)
        end
        let!(:bookshop_gift_order_is_null) do
          create(:bookshop_gift,
                 bookshop_gift_package_id: bookshop_gift_package.id,
                 order_id: nil)
        end
        let!(:bookshop_gift_order_not_null) do
          create(:bookshop_gift,
                 bookshop_gift_package_id: bookshop_gift_package.id,
                 order_id: 3)
        end
        it 'returns data' do
          get :index

          response = parsed_response['data'].first['attributes']
          expect(response['available_coupons']).to eq(1)
          expect(response['need_coupon']).to eq(false)
        end
      end
      context 'no bookshop gift packages' do
        it 'returns no data' do
          get :index
          expect(parsed_response['data']).to be_empty
        end
      end
    end
  end
end
