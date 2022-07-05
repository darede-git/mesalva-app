# frozen_string_literal: true

require 'me_salva/payment/iugu/subscription'

describe MeSalva::Payment::Iugu::Subscription do
  subject { described_class.new }

  before do
    stub_const('Iugu::Subscription', double)
  end

  describe '#fetch' do
    it 'returns a subscription' do
      subscription_id = 'ECF36F9AAF374D76A48646EDE8FE806D'
      allow_subscription_fetch(subscription_id)
      expect(subject.fetch(subscription_id)).to eq(Iugu::Subscription)
    end
  end

  describe '#create' do
    it 'creates a subscription' do
      plan_identifier = 'iugu-identifier'
      customer_id = 'FF3149CE52CB4A789925F154B489BFDD'

      allow(Iugu::Subscription).to receive(:create)
        .with(plan_identifier: plan_identifier,
              customer_id: customer_id,
              only_on_charge_success: true)
        .and_return(Iugu::Subscription)

      expect(subject.create(plan_identifier, customer_id))
        .to eq(Iugu::Subscription)
    end
  end

  describe '#suspend' do
    it 'suspend a subscription' do
      subscription_id = 'ECF36F9AAF374D76A48646EDE8FE806D'
      allow_subscription_fetch(subscription_id)

      allow(Iugu::Subscription).to receive(:suspend)
        .and_return(Iugu::Subscription)

      expect(subject.suspend(subscription_id))
        .to eq(Iugu::Subscription)
    end
  end

  def allow_subscription_fetch(subscription_id)
    allow(Iugu::Subscription).to receive(:fetch)
      .with(subscription_id)
      .and_return(Iugu::Subscription)
  end
end
