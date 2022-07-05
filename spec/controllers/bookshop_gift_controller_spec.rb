# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookshopGiftController, type: :controller do
  include PermissionHelper
  context '#index' do
    context 'with a user' do
      before { user_session }
      context 'with permission' do
        before { grant_test_permission('index') }
        context 'with a gift' do
          let!(:order) do
            create(:paid_order, user_id: user.id)
          end
          context 'and gift is available' do
            let!(:bookshop_gift) do
              create(:bookshop_gift, :available, order_id: order.id)
            end
            it 'returns user gift' do
              get :index
              expect(response).to have_http_status(:ok)
              expect(parsed_response['data']['attributes']['coupon'])
                .to eq(bookshop_gift.coupon)
            end
          end
          context 'and gift is not yet available' do
            let!(:bookshop_gift) do
              create(:bookshop_gift, order_id: order.id)
            end
            it 'returns no data' do
              get :index
              expect(response).to have_http_status(:no_content)
            end
          end
        end
        context 'without gift' do
          it 'returns no data' do
            get :index
            expect(response).to have_http_status(:no_content)
          end
        end
      end
    end
  end

  context '#create' do
    context 'as user' do
      before { user_session }
      context 'with permission' do
        before { grant_test_permission('create') }
        let!(:bookshop_gift_package) { create(:bookshop_gift_package) }
        context 'with valid params' do
          it 'creates a coupon' do
            get :create, params: { package_id: bookshop_gift_package.id,
                                   coupon: "CUPOMXP70" }

            assert_apiv2_response(:created, BookshopGift.last,
                                  V2::BookshopGiftSerializer,
                                  %i[bookshop_gift_package])
          end
        end
      end
    end
  end
end
