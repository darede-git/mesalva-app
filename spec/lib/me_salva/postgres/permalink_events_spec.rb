# frozen_string_literal: true

require 'me_salva/postgres/permalink_events'
require 'spec_helper'

describe MeSalva::Postgres::PermalinkEvents do
  subject { described_class.new }

  describe '#remove' do
    months = ENV['EVENT_MONTH_HISTORIZATION'].to_i

    it "removes permalink events older than #{months} months" do
      create(:permalink_event, created_at: (months + 1).months.ago)
      create(:permalink_event, created_at: (months - 1).months.ago)

      expect(PermalinkEvent.count).to eq(2)

      subject.remove

      expect(PermalinkEvent.count).to eq(1)
    end
  end
end
