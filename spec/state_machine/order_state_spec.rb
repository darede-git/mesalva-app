# frozen_string_literal: true

require 'rails_helper'
RSpec.describe OrderState, type: :model do
  let(:status) do
    { pending: 1,
      paid: 2,
      canceled: 3,
      expired: 4,
      invalid: 5,
      refunded: 6,
      not_found: 7,
      pre_approved: 8 }
  end

  describe 'after_transition' do
    it 'should updated order status with same state' do
      order = create(:order_valid)
      order.state_machine.transition_to!(:paid)
      expect(order.status).to eq(status[:paid])
    end
  end

  describe 'before_transition to paid' do
    let(:coupon) { double }
    before do
      allow(MeSalva::Campaign::Voucher::CouponGenerator).to receive(:new)
        .with(order).and_return(coupon)
      allow(coupon).to receive(:build)
      allow(CrmRdstationPaymentSuccessWorker).to receive(:perform_async)
        .with(order.id)
    end

    context 'from pre_approved' do
      let!(:order) { create(:order_valid, status: 8, user: user) }
      it 'should not create another access' do
        expect do
          order.state_machine.transition_to!(:paid)
        end.to change(Access, :count).by(0)
      end
    end
  end

  describe 'pre approved transitions' do
    context 'transitions from pending to pre approved' do
      let(:order) { create(:order_valid, user: user) }
      let(:order_invalid) { create(:pending_credit_card) }

      it 'should create access on valid parameters' do
        expect do
          order.state_machine.transition_to!(:pre_approved)
        end.to change(Access, :count).by(1)
        expect(order.status).to eq(status[:pre_approved])
      end

      it 'blocks transition if not bank slip' do
        expect do
          order_invalid.state_machine.transition_to(:pre_approved)
        end.to change(Access, :count).by(0)
        expect(order_invalid.status).to eq(status[:pending])
      end
    end

    context 'transaction to expired' do
      let(:order) { create(:order_valid, user: user) }
      it 'removes access from a expired pre aproved paiment' do
        order.state_machine.transition_to!(:pre_approved)
        order.state_machine.transition_to!(:expired)
        expect(Access.find_by_user_id(user.id).active).to eq(false)
      end
    end
  end

  describe 'after_transition to refunded' do
    context 'order with one access' do
      it 'should contest a access' do
        expect(UpdateIntercomUserWorker).to receive(:perform_async).exactly(4).times
        order = create(:order_valid)
        order.state_machine.transition_to!(:paid)
        order.state_machine.transition_to!(:refunded)

        access = Access.last
        expect(access.active).to be_falsey
      end
    end

    context 'order with twice access' do
      let!(:order) { create(:order_valid) }
      let!(:access) { create(:access_with_duration, order: order) }

      it 'should contest twice access' do
        order.state_machine.transition_to!(:paid)
        order.state_machine.transition_to!(:refunded)

        expect(access.reload.active).to be_falsey
        expect(Access.last.active).to be_falsey
      end
    end
  end

  describe 'after_transition to canceled' do
    let!(:order) { create(:order_valid, user: user) }
    before do
      expect(CrmRdstationPaymentRefusedWorker).to receive(:perform_async)
        .with(order.id)
    end

    it 'should created a new refused event' do
      order.state_machine.transition_to!(:canceled)
    end
  end

  describe 'after_transition to invalid' do
    let!(:order) { create(:order_valid, user: user) }
    before do
      expect(CrmRdstationPaymentRefusedWorker).to receive(:perform_async)
        .with(order.id)
    end

    it 'should created a new refused event' do
      order.state_machine.transition_to!(:invalid)
    end
  end
end
