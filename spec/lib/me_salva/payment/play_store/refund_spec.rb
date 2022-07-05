# frozen_string_literal: true

require 'me_salva/payment/play_store/refund'
require 'me_salva/payment/play_store/client'
require 'spec_helper'

describe MeSalva::Payment::PlayStore::Refund do
  before do
    allow_any_instance_of(MeSalva::Payment::PlayStore::Client)
      .to receive(:set_new_access_token).and_return(true)
  end

  subject { described_class.new(order) }
  let!(:order) do
    create(:in_app_order, :paid)
  end
  let(:client_class) do
    MeSalva::Payment::PlayStore::Client
  end

  describe '#perform' do
    context 'refunded order is the last one on its subscription' do
      context 'refund request works correctly' do
        before do
          allow_any_instance_of(client_class).to receive(:refund)
            .and_return(true)
        end
        it 'returns true' do
          expect(subject.perform).to be_truthy
        end
      end

      context 'refund request does not work correctly' do
        before do
          allow_any_instance_of(client_class).to receive(:refund)
            .and_return(false)
        end
        it 'returns true' do
          expect(subject.perform).to be_falsey
        end
      end
    end

    context 'refunded order is not the last one on its subscription' do
      let!(:last_order) do
        create(:in_app_order, :paid, user: order.user)
      end

      it 'returns false and does not make any request' do
        expect(subject.perform).to be_falsey
      end
    end
  end
end
