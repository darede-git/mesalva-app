# frozen_string_literal: true

require 'spec_helper'
require 'me_salva/permalinks/content'

describe MeSalva::Permalinks::Content do
  let(:node1) { create(:node) }
  let(:node2) { create(:node_area, parent_id: node1.id) }
  let(:node3) { create(:node_subject, parent_id: node2.id) }
  let(:slug) { "#{node1.slug}/#{node2.slug}/#{node3.slug}" }
  let(:entities) do
    [{ id: node1.id,
       name: node1.name,
       slug: node1.slug,
       color_hex: nil,
       entity_type: 'node',
       node_type: 'education_segment' },
     { id: node2.id,
       name: node2.name,
       slug: node2.slug,
       color_hex: 'FFFFFF',
       entity_type: 'node',
       node_type: 'area' },
     { id: node3.id,
       name: node3.name,
       slug: node3.slug,
       description: nil,
       image: { 'url' => nil },
       video: nil,
       color_hex: 'FFFFFF',
       created_by: nil,
       updated_by: nil,
       options: nil,
       node_type: 'subject',
       suggested_to: nil,
       pre_requisite: nil,
       listed: true,
       meta_title: node3.meta_title,
       meta_description: node3.meta_description,
       children: [],
       entity_type: 'node',
       'node-modules' => [],
       media: [] }]
  end
  let!(:permalink) do
    create(
      :permalink,
      slug: slug,
      nodes: [node1, node2, node3]
    )
  end
  subject { described_class.new(slug) }

  describe '.entities' do
    context 'when permalinks ends with node' do
      it 'returns the entities and serializes the last node' do
        expect(subject.entities).to eq(entities)
      end
    end
  end

  describe '.permalink' do
    it 'returns the permalink of the given slug' do
      expect(subject.permalink).to eq(permalink)
    end
  end

  describe '.serializable_hash_for' do
    it 'retuns a serializable hash for the entity in a namespace' do
      serialized_node = { id: node3.id,
                          name: node3.name,
                          slug: node3.slug,
                          description: nil,
                          image: { 'url' => nil },
                          video: nil,
                          children: [],
                          created_by: nil,
                          color_hex: 'FFFFFF',
                          entity_type: 'node',
                          options: nil,
                          node_type: 'subject',
                          pre_requisite: nil,
                          suggested_to: nil,
                          updated_by: nil,
                          meta_title: node3.meta_title,
                          meta_description: node3.meta_description,
                          'node-modules' => [],
                          listed: true,
                          media: [] }
      expect(subject.serializable_hash_for(node3)).to eq(serialized_node)
    end
  end
end
