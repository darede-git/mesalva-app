# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/permalinks/counter'
require 'me_salva/postgres/materialized_views'

describe MeSalva::Permalinks::Counter do
  include PermalinkBuildingHelper

  let!(:node) { create(:node) }
  let!(:node_module) { create(:node_module, nodes: [node]) }
  let!(:item) { create(:item, node_modules: [node_module]) }
  let!(:medium) { create(:medium, items: [item]) }
  let!(:build_permalink) { build_permalinks(node, :subtree) }

  let(:medium_count_response) do
    { 'text' => 0,
      'comprehension_exercise' => 0,
      'fixation_exercise' => 0,
      'video' => 1, 'pdf' => 0,
      'essay' => 0, 'streaming' => 0,
      'public_document' => 0,
      'soundcloud' => 0,
      'typeform' => 0,
      'book' => 0,
      'essay_video' => 0,
      'correction_video' => 0 }
  end

  describe 'permalink counter' do
    before { @permalinks = Permalink.all }

    context 'permalink ends with medium' do
      it 'assert counter values' do
        counter = described_class.new(permalink: @permalinks.last)

        expect(counter.seconds_duration).to eq(15)
        expect(counter.node_module_count).to eq(nil)
        expect(counter.medium_count).to eq(nil)
      end
    end

    context 'permalink ends with item' do
      it 'assert counter values' do
        counter = described_class.new(permalink: @permalinks.third)

        expect(counter.seconds_duration).to eq(15)
        expect(counter.node_module_count).to eq(nil)
        expect(counter.medium_count).to eq(medium_count_response)
      end
    end

    context 'permalink ends with node_module' do
      it 'assert counter values' do
        counter = described_class.new(permalink: @permalinks.second)

        expect(counter.node_module_count).to eq(nil)
        expect(counter.medium_count).to eq(medium_count_response)
      end
    end

    context 'permalink ends with node' do
      it 'assert counter values' do
        MeSalva::Postgres::MaterializedViews.new.refresh
        counter = described_class.new(permalink: @permalinks.first)

        expect(counter.node_module_count).to eq(1)
        expect(counter.medium_count).to eq(medium_count_response)
      end
    end
  end
end
