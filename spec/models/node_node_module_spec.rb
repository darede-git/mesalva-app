# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/permalinks/builder'

RSpec.describe NodeNodeModule, type: :model do
  context 'validations' do
    should_belong_to(:node, :node_module)
  end
  context 'on creation' do
    let(:education_segment) { create(:node) }
    let!(:node) do
      create(:node_area, parent_id: education_segment.id)
    end

    before do
      MeSalva::Permalinks::Builder.new(entity_id: education_segment.id,
                                       entity_class: 'Node')
                                  .build_subtree_permalinks
    end

    it "should create a permalink from node's last permalink" do
      @node_module = create(:node_module)
      expect do
        @node_module.node_ids = [node.id]
        MeSalva::Permalinks::Builder.new(entity_id: node.id,
                                         entity_class: 'Node')
                                    .build_subtree_permalinks
      end.to change(Permalink, :count).by(1)

      permalink = Permalink.last

      expect(node.permalinks).to include @node_module.permalinks.first
      expect(permalink.node_ids).to eq([education_segment.id, node.id])
      expect(permalink.node_module_id).to eq(@node_module.id)
      expect(permalink.slug)
        .to eq "#{education_segment.slug}/#{node.slug}/#{@node_module.slug}"
    end

    it 'should set permalink entity order' do
      create(:node_area, parent_id: node.id)
      Permalink.all.each do |permalink|
        expect(permalink.permalink_nodes.first.position).to eq 1

        expect(permalink.permalink_nodes.last.position)
          .to eq(permalink.permalink_nodes.count)

        positions = Array(1..permalink.permalink_nodes.count)
        permalink_node_positions = permalink.permalink_nodes.pluck(:position)
        expect(permalink_node_positions).to match(positions)
      end
    end
  end
  context 'on removal' do
    it 'removes related permalinks' do
      education_segment = create(:node)
      node_module = create(:node_module,
                           node_ids: [education_segment.id])
      MeSalva::Permalinks::Builder.new(entity_id: education_segment.id,
                                       entity_class: 'Node')
                                  .build_subtree_permalinks

      expect do
        node_module.destroy
      end.to change(Permalink, :count).by(-1)

      expect(Node.find(education_segment.id)).not_to be_nil
      expect(Node.find(education_segment.id).permalinks.count).to eq 1
    end
  end
end
