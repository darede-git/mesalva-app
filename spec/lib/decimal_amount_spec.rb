# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DecimalAmount do
  subject { described_class.new(amount) }

  describe "#to_i" do
    context "float 10.0" do
      let(:amount) { 10.0 }

      it "returns 1000" do
        expect(subject.to_i).to eq 1000
      end
    end

    context "float 10.01" do
      let(:amount) { 10.01 }

      it "returns 1001" do
        expect(subject.to_i).to eq 1001
      end
    end

    context "integer 10" do
      let(:amount) { 10 }

      it "returns 10" do
        expect(subject.to_i).to eq 10
      end
    end

    context "BigDecimal 10.0" do
      let(:amount) { BigDecimal("10.0") }

      it "returns 1000" do
        expect(subject.to_i).to eq 1000
      end
    end

    context "BigDecimal 10.1" do
      let(:amount) { BigDecimal("10.1") }

      it "returns 1010" do
        expect(subject.to_i).to eq 1010
      end
    end

    context "BigDecimal 10.01" do
      let(:amount) { BigDecimal("10.01") }

      it "returns 1001" do
        expect(subject.to_i).to eq 1001
      end
    end

    context 'injected object is not a number' do
      let(:amount) { Object.new }

      it 'raises an error' do
        expect do
          subject.to_i
        end.to raise_error DecimalAmount::NotNumber
      end
    end
  end
end
