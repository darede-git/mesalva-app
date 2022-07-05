# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookshopGiftCreateCouponWorker do
  let!(:package) do
    create(:package_valid_with_price)
  end
  let!(:bookshop_gift_package) do
    create(:bookshop_gift_package, package_id: package.id)
  end
  let!(:order) do
    create(:paid_order,
           user_id: user.id,
           package_id: package.id)
  end

  context 'perform' do
    context 'when coupons are available' do
      let!(:bookshop_gift) do
        create(:bookshop_gift,
               bookshop_gift_package_id: bookshop_gift_package.id)
      end

      before do
        subject.perform
      end

      it 'creates gift coupons for the specified packages' do
        expect(bookshop_gift.reload.order).not_to be_nil
      end

      context 'when orders have been refunded' do
        let!(:refunded_order) do
          create(:paid_order,
                 package_id: package.id)
        end
        let!(:bookshop_gift_refunded) do
          create(:bookshop_gift,
                 bookshop_gift_package_id: bookshop_gift_package.id)
        end

        it 'reverts bookshop gifts that have orders that have been refunded' do
          subject.perform
          expect(bookshop_gift_refunded.reload.order).not_to be_nil
          expect(bookshop_gift.reload.order).not_to be_nil

          refunded_order.update(status: 6)
          subject.perform
          expect(bookshop_gift_refunded.reload.order).not_to be_nil
          expect(bookshop_gift.reload.order).not_to be_nil
        end
      end
    end
  end
end
