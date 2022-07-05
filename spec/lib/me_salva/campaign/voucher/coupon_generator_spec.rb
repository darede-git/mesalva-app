# frozen_string_literal: false

require 'rails_helper'

describe MeSalva::Campaign::Voucher::CouponGenerator do
  let!(:order) { create(:order) }
  let(:time_format) { "%d/%m/%Y %H:%M:%S" }
  subject { described_class.new(order) }

  describe '#build' do
    before do
      ENV['VOUCHER_PACKAGES'] = order.package_id.to_s
      ENV['VOUCHER_STARTS_AT'] = Time.now.strftime(time_format)
      ENV['VOUCHER_EXPIRES_AT'] = (Time.now + 1.week).strftime(time_format)
    end

    context 'with valid attributes' do
      it 'creates a new lovefriday coupon' do
        expect do
          subject.build
        end.to change(ActionMailer::Base.deliveries, :count)
          .by(1).and change(Voucher, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      before do
        ENV['VOUCHER_PACKAGES'] = (order.package_id + 1).to_s
      end
      context 'invalid package' do
        it 'dont create lovefriday coupon' do
          expect do
            subject.build
          end.to change(ActionMailer::Base.deliveries, :count)
            .by(0).and change(Voucher, :count).by(0)
        end
      end

      context 'invalid date' do
        let(:start_at) { (Time.now - 1.week).strftime(time_format) }
        let(:expires_at) { (Time.now - 1.day).strftime(time_format) }
        before do
          ENV['VOUCHER_STARTS_AT'] = start_at
          ENV['VOUCHER_EXPIRES_AT'] = expires_at
        end
        it 'dont create lovefriday coupon' do
          expect do
            subject.build
          end.to change(ActionMailer::Base.deliveries, :count)
            .by(0).and change(Voucher, :count).by(0)
        end
      end
    end
  end
end
