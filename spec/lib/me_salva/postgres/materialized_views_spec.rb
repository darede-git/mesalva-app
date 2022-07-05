# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/postgres/materialized_views'
require 'active_record'

describe MeSalva::Postgres::MaterializedViews do
  describe '#refresh' do
    it 'refreshes content seconds counters' do
      %w[vw_node_seconds_duration vw_node_medium_count].each do |view|
        connection = double('Connection')

        expect(ActiveRecord::Base).to receive(:connection) { connection }
        expect(connection).to receive(:execute)
          .with("REFRESH MATERIALIZED VIEW #{view}")
      end

      subject.refresh
    end
  end
end
