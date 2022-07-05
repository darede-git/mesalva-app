# frozen_string_literal: true

require 'rails_helper'

describe NodeModuleCountHelper, type: :helper do
  describe '#node_module_count' do
    context 'node with no modules' do
      it 'returns 0' do
        node = create(:node)
        expect(node.node_module_count).to eq(0)
      end
    end

    context 'node with 3 related modules' do
      it 'returns 3' do
        node_module_list = create_list(:node_module, 3)
        node = create(:node)
        node.node_modules = node_module_list
        expect(node.node_module_count).to eq(3)
      end
    end

    context 'parent node with child having 5 related modules' do
      it 'returns 5 on the parent and the child' do
        parent_node = create(:node)
        node_module_list = create_list(:node_module, 5)
        child_node = create(:node,
                            parent_id: parent_node.id)
        child_node.node_modules = node_module_list
        expect(parent_node.node_module_count).to eq(5)
        expect(child_node.node_module_count).to eq(5)
      end
    end

    context 'parent node and child node with related modules' do
      it 'returns the sum of all modules  on the parent node' do
        parent_module_list = create_list(:node_module, 5)
        parent = create(:node)
        parent.node_modules = parent_module_list

        child_module_list = create_list(:node_module, 2)
        child = create(:node,
                       parent_id: parent.id)

        child.node_modules = child_module_list

        expect(parent.node_module_count).to eq(7)
        expect(child.node_module_count).to eq(2)
      end
    end
  end
end
