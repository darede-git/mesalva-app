# frozen_string_literal: true

require 'me_salva/crm/client'
require 'spec_helper'

describe MeSalva::Logs::Statistic do
  subject { described_class }

  describe '#save' do
    context "for a intercom synchronization object" do
      let!(:message_log) { attributes_for(:internal_log_statistic) }
      it 'saves a new log statistic' do
        described_class.new(MeSalva::Logs::Objects::Intercom.synchronization,
                            message_log[:category])
                       .save
        saved_log = InternalLog.last
        expect(saved_log.category).to eq(message_log[:category])
        expect(saved_log.log_type).to eq(message_log[:log_type])
        expect(saved_log.log).to eq(message_log[:log])
      end
    end
  end

  describe '#increment' do
    context "for a intercom synchronization object" do
      let!(:message_log) { attributes_for(:internal_log_statistic) }
      it 'increments one to the counter' do
        log = described_class.new(MeSalva::Logs::Objects::Intercom.synchronization,
                                  message_log[:category])
        5.times do
          log.increment_counter(:iterations)
          log.increment_counter(:users_found)
        end
        2.times do
          log.increment_counter(:student_leads_found)
          log.increment_counter(:student_leads_updated)
        end
        3.times do
          log.increment_counter(:unsubscribers_found)
          log.increment_counter(:unsubscribers_updated)
        end
        log.save
        saved_log = InternalLog.last
        expect(saved_log.category).to eq(message_log[:category])
        expect(saved_log.log_type).to eq(message_log[:log_type])
        expect(saved_log.log['iterations']).to eq(5)
        expect(saved_log.log['users_found']).to eq(5)
        expect(saved_log.log['student_leads_found']).to eq(2)
        expect(saved_log.log['student_leads_updated']).to eq(2)
        expect(saved_log.log['unsubscribers_found']).to eq(3)
        expect(saved_log.log['unsubscribers_updated']).to eq(3)
      end
    end
  end
end
