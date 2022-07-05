# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/permalinks/builder'

RSpec.describe NodeModuleItem, type: :model do
  include PermalinkAssertionHelper

  context 'validations' do
    should_belong_to(:node_module, :item)
  end

  context 'on removal' do
    before do
      @education_segment = create(:node)
      @node_module = create(:node_module,
                            node_ids: [@education_segment.id])
      @item = create(:item, node_module_ids: [@node_module.id])
      MeSalva::Permalinks::Builder.new(entity_id: @education_segment.id,
                                       entity_class: 'Node')
                                  .build_subtree_permalinks
    end
    context 'deleting entities' do
      it 'removes related permalinks' do
        expect do
          @item.destroy
        end.to change(Permalink, :count).by(-1)

        expect(NodeModule.find(@node_module.id)).not_to be_nil
        expect(NodeModule.find(@node_module.id).permalinks.count).to eq 1

        expect(Node.find(@education_segment.id)).not_to be_nil
        expect(Node.find(@education_segment.id).permalinks.count).to eq 2
      end
    end
    context 'deleting relationships' do
      it 'removes related permalinks' do
        expect do
          @item.node_module_items.first.destroy
        end.to change(Permalink, :count).by(-1)
      end
    end
  end
end
