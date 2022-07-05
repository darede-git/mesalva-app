# frozen_string_literal: true

require 'me_salva/payment/iugu/data'
require 'spec_helper'

describe MeSalva::Payment::Iugu::Data do
  let(:order) { double(credit_card?: true) }
  let!(:token) { double(delete: '') }
  let(:name) { double }
  let(:email) { double }
  let(:user) { double }
  let(:charge) { JSON.parse(File.read('spec/fixtures/charge_response.json')) }

  subject { described_class.new(order, user, token, name, email) }

  before do
    allow(subject).to receive(:broker_user).and_return(double)
    allow(subject).to receive(:save_broker_customer_id).and_return(true)
    allow(subject).to receive(:payment_with_credit_card).and_return(charge)
  end

  describe '#persist' do
    it 'persists the broker data' do
      expect(subject.persist).to eq(charge)
    end
  end
end
