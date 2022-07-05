# frozen_string_literal: true

require "rails_helper"

RSpec.describe MeSalva::Billing::Plan do
  let(:package) { create(:package_valid_with_price) }
  let(:response) { instance_double(::MeSalva::Payment::Response, id: "id") }

  subject { described_class }

  describe ".create" do
    it "returns a response" do
      expect(package.gateway_plan_price).to eq 10.0
      allow(MeSalva::Payment::Pagarme::Plan)
        .to receive(:create)
        .with(name: package.name, amount: 1000)
        .and_return(response)

      subject.create(package)

      expect(package.pagarme_plan_id).to eq "id"
    end
  end

  describe ".update" do
    before do
      allow(package).to receive(:pagarme_plan_id) { "123" }
    end

    it "returns a response" do
      expect(MeSalva::Payment::Pagarme::Plan)
        .to receive(:update)
        .with(id: "123", name: package.name)
        .and_return(response)

      subject.update(package)
    end
  end
end
