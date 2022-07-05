# frozen_string_literal: true

require 'rails_helper'

describe MeSalva::Logs::Message do
  subject { described_class }

  describe '#save' do
    context "for a intercom synchronization message" do
      let!(:message_log) { attributes_for(:internal_log_message) }
      it 'saves a new log message' do
        described_class.new(message_log[:category]).save(message_log[:log])
        saved_log = InternalLog.last
        expect(saved_log.category).to eq(message_log[:category])
        expect(saved_log.log_type).to eq('Message')
        expect(saved_log.log).to eq(message_log[:log])
      end
    end
  end
end
