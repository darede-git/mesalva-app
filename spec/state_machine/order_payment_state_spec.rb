# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderPaymentState, type: :model do
  let(:order) { create(:order_valid) }
  let!(:card1) { create(:payment, :card, order: order) }
  let!(:card2) { create(:payment, :card, order: order) }
  let!(:bank_slip) { create(:payment, :bank_slip, order: order) }

  context 'authorizing' do
    context 'when card' do
      it 'transitions to authorizing' do
        card1.state_machine.transition_to!(:authorizing)
      end
    end

    context 'when not card' do
      it 'does not transition to authorizing' do
        expect do
          bank_slip.state_machine.transition_to!(:authorizing)
        end.to raise_error Statesman::GuardFailedError
      end
    end
  end

  context 'capturing' do
    context 'when all cards were authorized' do
      before do
        card1.state_machine.transition_to!(:authorizing)
        card2.state_machine.transition_to!(:authorizing)
        card1.state_machine.transition_to!(:authorized)
        card2.state_machine.transition_to!(:authorized)
      end

      context 'when all bank slips are paid' do
        before { bank_slip.state_machine.transition_to!(:paid) }

        it 'transitions to capturing' do
          card1.state_machine.transition_to!(:capturing)
        end
      end

      context 'when not all bank slips are paid' do
        it 'does not transition to capturing' do
          expect do
            card1.state_machine.transition_to!(:capturing)
          end.to raise_error Statesman::GuardFailedError
        end
      end
    end

    context 'when a card is already on capturing' do
      before do
        card1.state_machine.transition_to!(:authorizing)
        card2.state_machine.transition_to!(:authorizing)
        card1.state_machine.transition_to!(:authorized)
        card2.state_machine.transition_to!(:authorized)
        bank_slip.state_machine.transition_to(:paid)
        card1.state_machine.transition_to!(:capturing)
      end

      it 'transitions to capturing' do
        card2.state_machine.transition_to!(:capturing)
      end
    end

    context 'when not all order payment cards were authorized' do
      context 'when one card authorization fail' do
        before do
          card1.state_machine.transition_to!(:authorizing)
          card2.state_machine.transition_to!(:authorizing)
          card1.state_machine.transition_to!(:authorized)
          card2.state_machine.transition_to!(:failed)
        end

        it 'does not transition to capturing' do
          expect do
            card1.state_machine.transition_to!(:capturing)
          end.to raise_error Statesman::GuardFailedError
        end
      end
    end
  end

  context 'when paying' do
    context 'when bank slip' do
      it 'transitions to paid' do
        bank_slip.state_machine.transition_to!(:paid)
      end
    end

    context 'when credit card' do
      it 'does not transition to paid' do
        expect do
          card1.state_machine.transition_to!(:paid)
        end.to raise_error Statesman::GuardFailedError
      end
    end
  end

  context 'when failed' do
    it 'voids all other cards' do
      expect(VoidCardWorker).to receive(:perform_async).with(card1.id)
      expect(VoidCardWorker).to receive(:perform_async).with(card2.id)
      card1.state_machine.transition_to!(:authorizing)
      card1.state_machine.transition_to!(:failed)
    end
  end

  context 'when authorized' do
    before do
      card1.state_machine.transition_to!(:authorizing)
      card2.state_machine.transition_to!(:authorizing)
    end

    context 'when all other cards are ready to start capturing' do
      before do
        card2.state_machine.transition_to!(:authorized)
        bank_slip.state_machine.transition_to!(:paid)
      end

      it 'attempts capturing cards' do
        expect(CaptureCardWorker).to receive(:perform_async).with(card1.id)
        expect(CaptureCardWorker).to receive(:perform_async).with(card2.id)
        card1.state_machine.transition_to!(:authorized)
      end
    end

    context 'when other cards are not ready to start capturing' do
      it 'does NOT attempt capturing cards' do
        expect(CaptureCardWorker).to_not receive(:perform_async)
        expect(CaptureCardWorker).to_not receive(:perform_async)
        card1.state_machine.transition_to!(:authorized)
      end
    end
  end

  context 'when paid' do
    it 'captures all cards' do
      expect(CaptureCardWorker).to receive(:perform_async).with(card1.id)
      expect(CaptureCardWorker).to receive(:perform_async).with(card2.id)
      card1.state_machine.transition_to!(:authorizing)
      card2.state_machine.transition_to!(:authorizing)
      card1.state_machine.transition_to!(:authorized)
      card2.state_machine.transition_to!(:authorized)
      bank_slip.state_machine.transition_to!(:paid)
    end
  end

  context 'when refunded' do
    before do
      card1.state_machine.transition_to!(:captured)
      card2.state_machine.transition_to!(:captured)
      card1.state_machine.transition_to!(:refunded)
    end
    it 'sets the order state as refunded' do
      expect(order.state_machine.current_state).to eq("refunded")
    end
  end
end
