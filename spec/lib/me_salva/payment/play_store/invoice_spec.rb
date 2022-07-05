# frozen_string_literal: true

require 'me_salva/payment/play_store/invoice'
require 'spec_helper'

describe MeSalva::Payment::PlayStore::Invoice do
  let(:invoice_attributes) do
    JSON.parse(File.read('spec/fixtures/google/order_data.json'))
  end
  describe '#new' do
    it 'should set the attributes correctly' do
      invoice = described_class.new(invoice_attributes)
      expect(invoice.order_id)
        .to eq(invoice_attributes['orderId'])
      expect(invoice.payment_state)
        .to eq(invoice_attributes['paymentState'])
      expect(invoice.expiry_time_in_seconds)
        .to eq(time_in_seconds(invoice_attributes['expiryTimeMillis']))
      expect(invoice.cancel_reason)
        .to eq(invoice_attributes['cancelReason'])
      expect(invoice.auto_renewing)
        .to eq(invoice_attributes['autoRenewing'])
      expect(invoice.broker_data)
        .to eq(invoice_attributes)
    end
  end

  describe '#paid_order?' do
    context 'invoice payment_state is 1' do
      it 'should return true' do
        expect(described_class.new('paymentState' => '1').paid_order?)
          .to be_truthy
      end
    end
    context 'invoice status different from 1' do
      it 'should return false' do
        expect(described_class.new('paymentState' => '0').paid_order?)
          .to be_falsey
      end
    end
  end

  describe '#canceled_order?' do
    context 'invoice canceled_reason is 1' do
      it 'should return true' do
        expect(described_class.new('cancelReason' => '1').canceled_order?)
          .to be_truthy
      end
    end
    context 'invoice canceled_reason is different from 1' do
      it 'should return false' do
        expect(described_class.new('cancelReason' => '0').paid_order?)
          .to be_falsey
      end
    end
  end

  describe '#current_state' do
    context 'cancel_reason is 1' do
      it 'should return :canceled' do
        expect(described_class.new('cancelReason' => '1').current_state)
          .to eq(:canceled)
      end
    end
    context 'payment_state is 1' do
      it 'should return :paid' do
        expect(described_class.new('paymentState' => '1').current_state)
          .to eq(:paid)
      end
    end
    context 'unknown state' do
      it 'should return :not_found' do
        expect(described_class.new({}).current_state).to eq(:not_found)
      end
    end
  end

  context 'methods with order as param' do
    let!(:order) do
      create(:in_app_order, broker_invoice: 'GPA.123')
    end

    describe '#current_order?' do
      let!(:invoice) do
        described_class.new('orderId' => 'GPA.123')
      end

      context 'order broker_invoice equals order_id' do
        it 'should return true' do
          expect(invoice.current_order?(order)).to be_truthy
        end
      end
      context 'order broker_invoice is different from invoice order id' do
        it 'should return false' do
          order.update!(broker_invoice: 'GPA.456')
          expect(invoice.current_order?(order)).to be_falsey
        end
      end
    end

    describe '#incomplete_recurrency_process?' do
      context 'is current order' do
        context 'payment is pending' do
          it 'should be true' do
            invoice_attributes.merge!('orderId' => 'GPA.123',
                                      'paymentState' => '0')
            invoice = described_class.new(invoice_attributes)
            expect(invoice.incomplete_recurrency_process?(order))
              .to be_truthy
          end
        end
        context 'payment is not pending' do
          it 'should be true' do
            invoice_attributes.merge!('orderId' => 'GPA.123',
                                      'paymentState' => '1')
            invoice = described_class.new(invoice_attributes)
            expect(invoice.incomplete_recurrency_process?(order))
              .to be_truthy
          end
        end
      end

      context 'is not current order' do
        context 'payment is pending' do
          it 'should be true' do
            invoice_attributes['paymentState'] = '0'
            invoice = described_class.new(invoice_attributes)
            expect(invoice.incomplete_recurrency_process?(order))
              .to be_truthy
          end
        end
        context 'payment is not pending' do
          it 'should be false' do
            invoice_attributes['paymentState'] = '1'
            invoice = described_class.new(invoice_attributes)
            expect(invoice.incomplete_recurrency_process?(order))
              .to be_falsey
          end
        end
      end
    end
  end

  def time_in_seconds(time_in_millis)
    Time.at(time_in_millis.to_i / 1000)
  end
end
