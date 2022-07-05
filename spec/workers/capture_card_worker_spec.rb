# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CaptureCardWorker do
  let!(:order) { create(:order_valid) }

  describe '.perform' do
    context 'with authorized charge' do
      let!(:card) do
        create(:payment, :card,
               order: order,
               card_token: 'card_ckljewknk0iyn0i9t63o9h49m')
      end
      context 'with valid attributes' do
        before do
          VCR.use_cassette("CaptureCardWorker before") do
            order.update(broker: 'pagarme')
            charging = MeSalva::Payment::Pagarme::Charge.new(card, 'custom billing name')
                                                        .perform(:authorize)
            card.update(pagarme_transaction_attributes:
              { transaction_id: charging.id, order_payment: card })
            card.state_machine.transition_to!(:authorized)
          end
        end

        it 'should capture card amount' do |example|
          VCR.use_cassette(test_name(example)) do
            subject.perform(card.id)

            expect(card.status).to eq('capturing')
          end
        end
      end
    end
  end
end
