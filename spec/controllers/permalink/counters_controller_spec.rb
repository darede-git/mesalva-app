# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/permalinks/counter'
require 'me_salva/postgres/materialized_views'

RSpec.shared_examples 'counters' do |entities|
  entities.each do |entity|
    describe Permalink::CountersController, type: :controller do
      let(:permalinks) { Permalink.all }
      let(:permalink_node_slug) { permalinks.first.slug }
      let(:permalink_node_module_slug) { permalinks.second.slug }
      let(:permalink_item_slug) { permalinks.third.slug }
      let(:permalink_medium_slug) { permalinks.last.slug }
      let!(:attributes) do
        { 'slug' => node_module.slug,
          'seconds-duration' => 15,
          'node-module-count' => 0,
          'medium-count' => medium_count_hash }
      end
      let!(:node_modules_hash) do
        { 'node-modules' => attributes_for(node_module) }
      end
      let!(:items_hash) do
        { 'items' => attributes_for(item) }
      end
      let!(:media_hash) { { 'media' => [] } }

      let(:permalink_node_response) do
        counter_hash(permalink_node_slug, 1, node_modules_hash)
      end
      let(:permalink_node_module_response) do
        counter_hash(permalink_node_module_slug, 0, items_hash)
      end
      let(:permalink_item_response) do
        counter_hash(permalink_item_slug, 0, media_hash, 15)
      end
      let(:permalink_medium_response) do
        {
          'permalink-counter' => {
            'slug' => permalink_medium_slug,
            'seconds-duration' => 15,
            'node-module-count' => 0,
            'medium-count' => {}
          }
        }
      end
      let(:medium_count_hash) do
        { 'text' => 0,
          'comprehension-exercise' => 0,
          'fixation-exercise' => 0,
          'video' => 1,
          'pdf' => 0,
          'essay' => 0,
          'streaming' => 0,
          'public-document' => 0,
          'soundcloud' => 0,
          'typeform' => 0,
          'book' => 0,
          'essay-video' => 0,
          'correction-video' => 0 }
      end
      let!(:refresh_materialized_views) do
        MeSalva::Postgres::MaterializedViews.new.refresh
      end

      describe 'GET #show' do
        describe 'permalink counter' do
          context "permalink ends with #{entity}" do
            it 'returns valid permalink counter hash' do
              get :show,
                  params: { slug: public_send("permalink_#{entity}_slug") }

              expect(response.headers.keys).not_to include_authorization_keys
              expect(parsed_response)
                .to eq(public_send("permalink_#{entity}_response"))
            end
          end
        end
      end
    end
  end

  def counter_hash(slug, node_module_count, child, seconds_duration = 0)
    hash = { 'permalink-counter' => {
      'slug' => slug,
      'seconds-duration' => seconds_duration,
      'node-module-count' => node_module_count,
      'medium-count' => medium_count_hash
    } }
    hash['permalink-counter'].merge!(child) if child
    hash
  end

  def attributes_for(entity)
    seconds_duration = entity.instance_of?(Item) ? 15 : 0
    [{ 'slug' => entity.slug,
       'seconds-duration' => seconds_duration,
       'node-module-count' => 0,
       'medium-count' => medium_count_hash }]
  end
end

RSpec.describe Permalink::CountersController, type: :controller do
  include PermalinkBuildingHelper

  let!(:node) { create(:node) }
  let!(:node_module) { create(:node_module, nodes: [node]) }
  let!(:item) { create(:item, node_modules: [node_module]) }
  let!(:medium) { create(:medium, items: [item]) }
  let!(:build_permalink) { build_permalinks(node, :subtree) }

  describe 'per context' do
    it_should_behave_like 'counters', %w[node node_module item medium]
  end
end
