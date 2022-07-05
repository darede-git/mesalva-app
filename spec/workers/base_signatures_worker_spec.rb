# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'subscription worker' do |workers|
  workers.each_key do |status|
    describe "#{status.classify}SubscriptionsWorker".constantize do
      let(:package) { create(workers[status][:package]) }
      let(:order) do
        create("#{status}_order".to_sym, package_id: package.id,
                                         broker: 'iugu')
      end

      subject { described_class.new }

      describe '#perform' do
        it 'updates the order' do
          client = double(update: true)
          allow(MeSalva::Signature::Order).to receive(:new) { client }

          expect(client).to receive(workers[status][:method]).with(order)
          subject.perform
        end
      end
    end
  end
end

RSpec.describe BaseSignaturesWorker do
  describe 'subscription worker' do
    jobs = { 'pending' => { method: :update, package: :package_subscription },
             'expired' => { method: :renew, package: :package_subscription },
             'oneshot_bank_slip' => { method: :update,
                                      package: :package_with_duration },
             'oneshot_credit_card' => { method: :update,
                                        package: :package_with_duration } }
    it_should_behave_like 'subscription worker', jobs
  end
end
