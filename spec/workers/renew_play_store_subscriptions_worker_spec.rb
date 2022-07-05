# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RenewPlayStoreSubscriptionsWorker do
  describe '#perform' do
    subject { described_class.new }
    let!(:pagarme_order) do
      create(:order_valid)
    end
    let!(:not_processed_expired_order) do
      create(:in_app_order, :expired, :paid)
    end
    let!(:processed_expired_order) do
      create(:in_app_order, :expired, :paid, processed: true)
    end
    let!(:not_expired_order) do
      create(:in_app_order, :paid)
    end
    let(:order_info_response) do
      JSON.parse(File.read('spec/fixtures/google/order_data.json'))
    end
    let(:client_lib_double) do
      double(get_order_info: order_info_response)
    end
    let(:scoped_orders) do
      Order.expired_orders.by_play_store
    end

    before do
      allow(MeSalva::Payment::PlayStore::Client)
        .to receive(:new).and_return(client_lib_double)
    end
    it 'renews expired play store orders' do
      scoped_orders.each do |order|
        expect_any_instance_of(MeSalva::Payment::PlayStore::Subscription)
          .to receive(:process).with(order)
      end

      Order.where('id NOT IN (?)', scoped_orders.pluck(:id)).each do |order|
        expect_any_instance_of(MeSalva::Payment::PlayStore::Subscription)
          .not_to receive(:process).with(order)
      end
      subject.perform
    end
  end
end
