# frozen_string_literal: true

require "rails_helper"

RSpec.describe MeSalva::Payment::Pagarme::Plan, "Integration", web: true do
  subject { described_class }

  describe ".create .update" do
    let(:name) { "Test Package 1580320260" }
    let(:updated_name) { "Updated #{name}" }

    it "creates a plan remotely" do |example|
      VCR.use_cassette(test_name(example)) do
        result = subject.create(name: name, amount: 1000)

        expect(result.id).to be > 1
        expect(result.amount).to eq 1000
        expect(result.days).to eq 30
        expect(result.installments).to eq 1
        expect(result.name).to eq name
        expect(result.payment_methods).to eq %w[boleto credit_card]
        expect(result.trial_days).to eq 0

        # updates the plan
        result = subject.update(id: result.id, name: updated_name)
        expect(result.name).to eq updated_name
      end
    end

    context 'value is float' do
      it "raises" do
        expect do
          subject.create(name: name, amount: 10.0)
        end.to raise_error described_class::InvalidAmount
      end
    end
  end
end
