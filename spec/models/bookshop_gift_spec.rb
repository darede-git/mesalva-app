# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookshopGift, type: :model do
  context 'validations' do
    it { should belong_to(:order) }
    it { should belong_to(:bookshop_gift_package) }
  end

  context 'first_by_user' do
    let!(:order) do
      create(:paid_order, user_id: user.id)
    end
    let!(:bookshop_gift) do
      create(:bookshop_gift, order_id: order.id)
    end
    it 'returns the first coupon of the user' do
      expect(BookshopGift.by_user(user).first).to eq(bookshop_gift)
    end
  end
end
