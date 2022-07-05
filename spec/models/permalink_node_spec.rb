# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PermalinkNode, type: :model do
  let!(:permalink_node) do
    create(:permalink_node,
           node: create(:node),
           permalink: create(:permalink))
  end

  should_belong_to(:node, :permalink)
  should_be_present(:permalink, :node)

  context 'removing the permalink' do
    it 'removes related permalink_nodes without removing nodes' do
      permalink = create(:permalink)
      node = create(:node)
      permalink.nodes = [node]
      expect do
        permalink.destroy
      end.to change(PermalinkNode, :count).by(-1)
      expect(Node.find(node.id)).to eq node
    end
  end
end
