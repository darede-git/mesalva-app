# frozen_string_literal: true

require 'rails_helper'

describe MeSalva::Permalinks::ExerciseList do
  include PermalinkBuildingHelper

  let!(:node) { create(:node) }
  let!(:node_module) { create(:node_module, nodes: [node]) }
  let!(:item) { create(:item, node_modules: [node_module]) }
  let!(:medium) { create(:medium, items: [item]) }
  let!(:build_permalink) { build_permalinks(node, :subtree) }

  context '#results' do
    it 'returns constructed object' do
      expect(described_class.new(Permalink.last.slug).results.first).to \
        include(:statement, :correct, :difficulty, :answers)
    end
  end
end
