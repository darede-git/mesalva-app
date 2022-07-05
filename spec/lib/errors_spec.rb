# frozen_string_literal: true

require "rails_helper"

RSpec.describe Errors do
  let(:item) { StandardError.new("Some error") }

  subject { described_class.new(item) }

  describe "#notify_engineers" do
    it "sends error to NewRelic" do
      expect(NewRelic::Agent)
        .to receive(:notice_error)
        .with(item, message: "custom msg")
      subject.notify_engineers("custom msg")
    end
  end
end
